class BriefsController < ApplicationController
  include ActionView::Helpers::TextHelper
  
  # needs login for all actions
  before_filter :require_user
  
  before_filter :require_account_brief_permissions, :only => [:new, :create]
  
  # filters for record owners
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  after_filter :record_user_view, :only => [:show]

  # ensure brief is active
  before_filter :require_active_brief, :only => [:edit]

  helper_method :completed_briefs, :available_templates
  
  add_breadcrumb 'dashboard', "/dashboard"
  
  add_breadcrumb 'create a new brief', :new_object_path, :only => [:new, :create]
  
  def current_objects
    @current_objects ||= current_user.briefs.active.by_account(current_account, {:order => "updated_at DESC"}).ordered
  end
  
  def current_object    
    @current_object ||= current_user.briefs.find(params[:id], :include => [ { :user_briefs => :user}, { :brief_items_answered => [:brief, :questions, { :timeline_events => :subject }], :comments => [:user] } ])
  end
  
  make_resourceful do
    belongs_to :user
    actions :all
        
    before :index do
      completed_briefs(:limit => 5, :order => "updated_at DESC")
      
      # TODO - refactor this 
      #@unanswered_questions = Question.find_all_by_brief_id(current_user.briefs, :conditions => ["answered_by_id IS NULL AND created_at > ? AND user_id != ?", 7.days.ago, current_user.id], :order => "created_at DESC")
      #@answered_questions = Question.find_all_by_brief_id(current_user.briefs, :conditions => ["answered_by_id != FALSE AND created_at > ? AND answered_by_id != ?", 7.days.ago, current_user.id], :order => "created_at DESC")
      #@merged_questions = (@unanswered_questions + @answered_questions).uniq 

      @tags = Tag.find_by_sql(["SELECT tags.*, COUNT(*) AS count FROM `tags` 
                                INNER JOIN taggings 
                                ON tags.id = taggings.tag_id 
                                AND taggings.context = 'tags'
                                AND taggings.taggable_id IN (?) 
                                INNER JOIN briefs 
                                ON briefs.id = taggings.taggable_id 
                                AND briefs.state IN ('published', 'draft')
                                GROUP BY tags.id, tags.name
                                HAVING COUNT(*) > 0
                                ORDER BY count DESC, tags.name ASC", @current_objects])
                      
      # Quick and dirty filtering by tags
      # This hooks into acts_as_taggable and returns
      # any projects tagged with the parameter
      if params[:t]
        @current_objects = @current_objects.tagged_with(params[:t]).uniq
      end
    end
    
    before :show do
      add_breadcrumb truncate(current_object.title, :length => 30), object_path
      @brief_proposals = current_object.proposal_list_for_user(current_user).group_by(&:state)
      @user_question ||= current_object.questions.build(session[:previous_question])
      #session[:return_to] = request.request_uri
    end
    
    before(:new, :create) do
      available_templates
    end
    
    before :create do
      current_object.account = current_account
      current_object.author = current_user
      current_object.template_brief = TemplateBrief.find(params[:brief][:template_brief_id]) if params[:brief][:template_brief_id].present?
      current_object.template_brief ||= available_templates.first
    end
              
    before(:edit, :update) do
      add_breadcrumb truncate(current_object.title, :length => 30), object_path
      add_breadcrumb 'edit brief', :edit_object_path
    end

    # We need to apply the current_account for acts_as_taggable_on so a virtual attribute is used
    # (tag_field) to hold the params. In this filter we build the current_account in 
    # so the current account is applied in the taggings table as tagger_id and tagger_type
    # This allows filtering of tags on a per account basis
    # For more documentation on acts_as_taggable_on see http://github.com/mbleigh/acts-as-taggable-on
    before(:create, :update) do
      current_account.tag(current_object, :with => params[:brief][:tag_field], :on => :tags)
    end

    after :create do
      flash[:notice] = "Brief was successfully created"
    end
    
    before :update do
      @brief_items_changed = current_object.brief_items_changed?(params[:brief][:brief_items_attributes]) if params[:brief][:brief_items_attributes].is_a? Hash
    end
    after :update do
      if params[:brief].keys.include?("_call_state")
        flash[:notice] = "Brief has been saved and marked as #{current_object.state}."
      else
        flash[:notice] = "Brief was successfully edited"
      end
      
      recipients = current_object.users.collect{ |user| user.email unless user.pending? }.compact - [current_user.email]
      
      if @brief_items_changed.present? and recipients.present?
        NotificationMailer.deliver_brief_section_updated(current_object.id, recipients, current_user.id, @brief_items_changed.collect(&:id))
      end
      
    end
    
    response_for(:create) do |format|
      format.html { redirect_to edit_object_path }
    end
    
    response_for(:index) do |format|
      format.html
    end
    
    response_for(:update, :update_fails) do |format|
      format.html { redirect_to :action => current_object.draft? ? 'edit' : 'show' }
      format.json { render :json => current_object.reload.to_json(:include => [:user_briefs], :methods => [:json_errors, :brief_role]) }
      
      format.js {
        # if (removed = current_object.user_briefs.select(&:marked_for_destruction?).map(&:user)).present?
        #           render :partial => 'collaboration_user', :collection => removed
        #         else
        #           render :nothing => true
        #         end
        render :partial => 'briefs/update_collaborators_form', :locals => {:current_object => @brief}
      }
    end
  
    response_for(:show, :show_fails) do |format|
    
      format.html { 
                
        if current_object.draft? 
          redirect_to(:action => 'edit') 
        else
          if params[:print_mode].present?
            @print_mode = params[:print_mode]
            render(:action => 'print', :layout => false) 
          else
            render 
          end
        end
        
      }
      
      format.js { render :layout => false }
      format.json { render :json => current_object }
    end
    
  end
  
  def watch
    if !record_owner?      
      current_user.toggle_watch!(current_object)
    end
    
    respond_to do |format|
      format.html { redirect_to object_path }
    end
  end
  
  def clean
    # POST request only. (routes.rb)
    # 
    # Deletes all history items, timeline events, comments, questions (and answers) from this Brief and its
    # BriefItem's.
    
    if params[:id].present?
      brief = Brief.find(:first, :conditions => {:id => params[:id]})
      if brief.present? and brief.clean_brief!
        flash[:notice] = "The brief was cleared successfully"
      else
        flash[:notice] = "Sorry, the brief could not be cleared."
      end
    end
    
    redirect_to :action => :show
  end
  
  
  # TODO - remove this action, and look at putting a filter param in the routes
  # so you can still have briefs/completed but it actually calls index
  # and passes a param .. or even just have briefs?filter=completed meh.
  
  def completed
    completed_briefs({:order => "updated_at DESC"})
  end
  
  private
  
  def completed_briefs(options = {})
    @completed_briefs ||= current_user.briefs.complete.by_account(current_account, options)
  end
     
  def require_owner
    redirect_to briefs_path and return unless record_owner?
  end
  
  def require_owner_if_not_published
    redirect_to briefs_path and return if (!record_owner? && !current_object.published?)
  end

  def record_owner?
    current_object.belongs_to?(current_user)
  end
  
  def record_user_view
    current_object.user_briefs.for_user(current_user).touch(:last_viewed_at)
  end
  
  def require_account_brief_permissions
    not_found unless current_user_can_create_briefs?
  end
  
  def current_brief
    current_object
  end
  
  def available_templates
    @available_templates ||= current_account.template_briefs
  end
  
end
