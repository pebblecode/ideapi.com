class Proposal < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  validates_uniqueness_of :brief_id, 
    :scope => :user_id, 
    :message => "You are already pitching for this brief"

  validates_presence_of :title, :long_description
  
  has_attached_file :attachment
  
  def published?
    published_at.present?
  end
  
  def draft?
    !published?
  end
  
  def publish!
    update_attribute(:published_at, Time.now) unless published?
    return published?
  end
  
end
