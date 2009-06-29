class BriefsController < ApplicationController
  
  before_filter :require_user
  
  helper_method :drafts, :published
  
  def current_objects
    @current_objects ||= (drafts + published)
  end
  
  make_resourceful do
    belongs_to :author, :creative
    actions :all
  end
  
  private
  
  def parent_object
    current_user
  end
  
  def drafts
    @drafts ||= parent_object.briefs.draft
  end
  
  def published
    @published ||= parent_object.briefs.published
  end

end
