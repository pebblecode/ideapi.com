class BriefsController < ApplicationController
  
  before_filter :require_user
#  before_filter :require_author
  
  helper_method :drafts, :published, :current_brief_items
  
  def current_objects
    @current_objects ||= (drafts + published)
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
  end
  
  def publish
    current_object.publish!
    respond_to do |format|
      format.html { redirect_to brief_path(current_object) }
    end
  end
  
  private
  
  alias :parent_object :current_user
  
  def drafts
    @drafts ||= parent_object.briefs.draft
  end
  
  def published
    @published ||= parent_object.briefs.published
  end

  def current_brief_items
    return false if !current_object
    @current_brief_items ||= (current_object.published? ? current_object.brief_items.answered : current_object.brief_items)
  end

end
