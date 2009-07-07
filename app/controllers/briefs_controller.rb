class BriefsController < ApplicationController
  
  before_filter :require_user
  before_filter :require_author, :except => [:index, :show]
  before_filter :require_author_if_draft, :except => [:index]
  before_filter :require_owner, :only => [:edit, :update]
  
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
    
    response_for(:index) do |format|
      # display a different view depending on the user type
      format.html { render :action => choose_user_action }
    end
    
    response_for(:show) do |format|
      format.html { render :action => choose_user_action }
    end
  end
  
  def publish
    current_object.publish!
    respond_to do |format|
      format.html { redirect_to brief_path(current_object) }
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
    record_author?
  end
  
  def require_author_if_draft
    if current_object && current_object.draft?
      redirect_to briefs_path if !record_author?
    else
      true
    end
  end

  def record_author?
    if current_object && current_object.respond_to?(:author)
      current_object.author == current_user 
    else
      false
    end
  end

  def choose_user_action(action = nil)
    action = action_name if action.nil?
    user_action_name(action)
  end
  
  def user_action_name(action)
    type = user_type
        
    # are we looking at a record?
    if action_name != "index"
      # dont render 'author' template to authors who don't own records
      type = (user_type == "author" && !record_author?) ? "creative" : user_type
    end
    
    # join the action with the type => ie index_creative
    [action, type].join("_")
  end

end
