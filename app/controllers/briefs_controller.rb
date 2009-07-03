class BriefsController < ApplicationController
  
  before_filter :require_user
#  before_filter :require_author
  
  helper_method :drafts, :published, :current_brief_items
  
  def current_objects
    @current_objects ||= author? ? author_briefs : creative_briefs
  end
  
  def current_object
    @current_object ||= (  
      begin
        parent_object.briefs.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        kill_session
      end
    )
  end
  
  make_resourceful do
    belongs_to :author, :creative
    actions :all
    
    before :create do
      current_object.template_brief = TemplateBrief.last
      current_object.author = parent_object
    end
    
    response_for(:index) do |format|
      format.html { render :action => "index_#{user_type}" }
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
  
  # scoped to a creative
  def creative_briefs
    @creative_briefs ||= parent_object.briefs
  end
   
  class_eval do
    %w(watching pitching under_review complete).each do |action_name|
      define_method("#{action_name}?", lambda { current_object.briefs.send(action_name) }) 
    end
  end
  
  # scoped to an author
  def author_briefs
    drafts + published
  end
  
  def drafts
    @drafts ||= author? ? parent_object.briefs.draft : []
  end
  
  def published
    @published ||= author? ? parent_object.briefs.published : []
  end

  # only show answered items on a published brief
  def current_brief_items
    return [] if !current_object || !author?
    @current_brief_items ||= (current_object.published? ? current_object.brief_items.answered : current_object.brief_items)
  end
  
  #override make_resouceful
  def user_type
    parent_object.class.to_s.downcase
  end

end
