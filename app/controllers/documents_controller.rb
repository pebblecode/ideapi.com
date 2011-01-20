class DocumentsController < ApplicationController
  include ActionView::Helpers::TextHelper
    
  # needs login for all actions
  before_filter :require_user
  
  before_filter :require_account_document_permissions, :only => [:new, :create]
  
  # filters for record owners
  before_filter :require_owner, :only => [:edit, :update, :destroy]

  after_filter :record_user_view, :only => [:show]

  # ensure document is active
  before_filter :require_active_document, :only => [:edit]

  helper_method :completed_documents, :available_templates, :page_title
  
  add_breadcrumb 'documents', "/documents"
  
  add_breadcrumb 'create a new document', :new_object_path, :only => [:new, :create]
  
  def current_objects
    @current_objects ||= current_user.documents.active.by_account(current_account, {:order => "updated_at DESC"}).ordered
  end
  
  def current_object    
    @current_object ||= current_user.documents.find(params[:id], :include => [ { :user_documents => :user}, { :document_items_answered => [:document, :questions, { :timeline_events => :subject }], :comments => [:user] } ])
  end
  
  make_resourceful do
    belongs_to :user
    actions :all
        
    before :index do
      completed_documents(:limit => 5, :order => "updated_at DESC")
      
      # TODO - refactor this 
      #@unanswered_questions = Question.find_all_by_document_id(current_user.documents, :conditions => ["answered_by_id IS NULL AND created_at > ? AND user_id != ?", 7.days.ago, current_user.id], :order => "created_at DESC")
      #@answered_questions = Question.find_all_by_document_id(current_user.documents, :conditions => ["answered_by_id != FALSE AND created_at > ? AND answered_by_id != ?", 7.days.ago, current_user.id], :order => "created_at DESC")
      #@merged_questions = (@unanswered_questions + @answered_questions).uniq 

      @tags = Tag.find_by_sql(["SELECT tags.*, COUNT(*) AS count FROM `tags` 
                                INNER JOIN taggings 
                                ON tags.id = taggings.tag_id 
                                AND taggings.context = 'tags'
                                AND taggings.taggable_id IN (?) 
                                INNER JOIN documents 
                                ON documents.id = taggings.taggable_id 
                                AND documents.state IN ('published', 'draft')
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
      @document_proposals = current_object.proposal_list_for_user(current_user).group_by(&:state)
      @user_question ||= current_object.questions.build(session[:previous_question])
      #session[:return_to] = request.request_uri
    end
    
    before(:new, :create) do
      available_templates
    end
    
    before :create do
      current_object.account = current_account
      current_object.author = current_user
      current_object.template_document = TemplateDocument.find(params[:document][:template_document_id]) if params[:document][:template_document_id].present?
      current_object.template_document ||= available_templates.first
    end
              
    before(:edit, :update) do
      add_breadcrumb truncate(current_object.title, :length => 30), object_path
    end

    # We need to apply the current_account for acts_as_taggable_on so a virtual attribute is used
    # (tag_field) to hold the params. In this filter we build the current_account in 
    # so the current account is applied in the taggings table as tagger_id and tagger_type
    # This allows filtering of tags on a per account basis
    # For more documentation on acts_as_taggable_on see http://github.com/mbleigh/acts-as-taggable-on
    before(:create, :update) do
      current_account.tag(current_object, :with => params[:document][:tag_field], :on => :tags)
    end

    after :create do
      flash[:notice] = "Document was successfully created"
    end
    
    before :update do
      @document_items_changed = current_object.document_items_changed?(params[:document][:document_items_attributes]) if params[:document][:document_items_attributes].is_a? Hash
    end
    after :update do
      if params[:document].keys.include?("_call_state")
        flash[:notice] = "Document has been saved and marked as #{current_object.state}."
      else
        flash[:notice] = "Document was successfully edited"
      end
      
      recipients = current_object.users.collect{ |user| user.email unless user.pending? }.compact - [current_user.email]
      
      if @document_items_changed.present? and recipients.present?
        begin
          NotificationMailer.deliver_document_section_updated(current_object.id, recipients, current_user.id, @document_items_changed.collect(&:id))
        rescue
          nil
        end
        
      end
      
    end
    
    response_for(:create) do |format|
      format.html { redirect_to object_path }
    end
    
    response_for(:index) do |format|
      format.html{
        render
      }
    end
    
    response_for(:update, :update_fails) do |format|
      format.html { redirect_to :action => 'show' }
      format.json { render :json => current_object.reload.to_json(:include => [:user_documents], :methods => [:json_errors, :document_role]) }
      
      format.js {
        # if (removed = current_object.user_documents.select(&:marked_for_destruction?).map(&:user)).present?
        #           render :partial => 'collaboration_user', :collection => removed
        #         else
        #           render :nothing => true
        #         end
        if params[:render].present?
          render :partial => 'documents/document_partials/' << params[:render], :locals => {:current_object => @document}
        else
          render :partial => 'documents/update_collaborators_form', :locals => {:current_object => @document}
        end
      }
    end
  
    response_for(:show, :show_fails) do |format|
    
      format.html {
        if params[:print_mode].present?
          @print_mode = params[:print_mode]
          render(:action => 'print', :layout => false)
        else
          render
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
    # Deletes all history items, timeline events, comments, questions (and answers) from this Document and its
    # DocumentItem's.
    
    if params[:id].present?
      document = Document.find(:first, :conditions => {:id => params[:id]})
      if document.present? and document.clean_document!
        flash[:notice] = "The document was cleared successfully"
      else
        flash[:notice] = "Sorry, the document could not be cleared."
      end
    end
    
    redirect_to :action => :show
  end
  
  # TODO - remove this action, and look at putting a filter param in the routes
  # so you can still have documents/completed but it actually calls index
  # and passes a param .. or even just have documents?filter=completed meh.
  
  def completed
    completed_documents({:order => "updated_at DESC"})
  end
  
  private
  
  def completed_documents(options = {})
    @completed_documents ||= current_user.documents.complete.by_account(current_account, options)
  end
     
  def require_owner
    redirect_to documents_path and return unless record_owner?
  end
  
  def require_owner_if_not_published
    redirect_to documents_path and return if (!record_owner? && !current_object.published?)
  end

  def record_owner?
    current_object.belongs_to?(current_user)
  end
  
  def record_user_view
    current_object.user_documents.for_user(current_user).touch(:last_viewed_at)
  end
  
  def require_account_document_permissions
    not_found unless current_user_can_create_documents?
  end
  
  def current_document
    current_object
  end
  
  def available_templates
    @available_templates ||= current_account.template_documents
  end
  
end
