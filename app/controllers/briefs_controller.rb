class BriefsController < ApplicationController
  # needs login for all actions
  before_filter :require_user
  
  # filters for author
  before_filter :require_author, :except => [:index, :show, :browse, :watch]
  before_filter :require_author_if_not_published, :only => [:show]
  
  # filters for record owners
  before_filter :require_owner, :only => [:edit, :update, :destroy]
  
  # filters for creatives
  before_filter :require_creative, :only => [:watch]
  
  # get the brief items (depending on brief state)
  helper_method :current_brief_items
  
  def current_objects
    @current_objects ||= author? ? author_briefs : creative_briefs
  end
  
  make_resourceful do
    belongs_to :author, :creative
    actions :all
    
    before :create do
      current_object.template_brief = TemplateBrief.last
      current_object.author = parent_object
    end
    
    response_for(:create) do |format|
      format.html { redirect_to edit_object_path }
    end
    
    response_for(:index) do |format|
      # display a different view depending on the user type
      format.html { render :action => user_action }
    end
    
    response_for(:show) do |format|
      format.html { 
        render :action => user_action
      }
    end
  end
  
  def publish
    current_object.publish!
    respond_to do |format|
      format.html { redirect_to brief_path(current_object) }
    end
  end
  
  def browse
    @search_results = Brief.search(params[:q])
    respond_to do |format|
      format.html
    end
  end
  
  def watch
    # this should be guarded by the filter but just incase
    if creative?      
      current_user.toggle_watch!(current_object)
    end
    
    respond_to do |format|
      format.html { redirect_to object_path }
    end
  end
  
  private
  
  # parent_object is standard make_resourceful accessor
  # overwrite with our current logged in user
  alias :parent_object :current_user
  
  # expose the briefs
  # check out lib/ideapi/expose_briefs.rb for the gory details
  include Ideapi::ExposeBriefs
  
  expose_briefs_as :author, :scope => [:draft, :published]
  expose_briefs_as :creative, :scope => [:watching, :pitching, :under_review, :complete]
  
  # only show answered items on a published brief
  def current_brief_items
    @current_brief_items ||= (current_object.published? ? send(:current_object).brief_items.answered : current_object.brief_items)
  end
  
  #override make_resouceful
  def user_type
    @user_type ||= parent_object.class.to_s.downcase
  end
  
  def require_owner
    redirect_to briefs_path and return if !record_author?
  end
  
  def require_author_if_not_published
    redirect_to briefs_path and return if (!record_author? && !current_object.published?)
  end

  def record_author?
    current_object.belongs_to?(current_user)
  end
  
  def user_action(action = action_name)
    @user_action_name ||= (
      type = user_type
        
      # are we looking at a record?
      if action_name != "index"
        # dont render 'author' template to authors who don't own records      
        type = "creative" if (type == "author" && !record_author?)
      end
    
      # join the action with the type => ie index_creative
      [action, type].join("_")
    )
  end

end
