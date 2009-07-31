class BriefUserView < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  validates_presence_of :brief_id, :user_id
  validates_uniqueness_of :brief_id, :scope => [:user_id]
  
  def viewed!
    increase_view_count
    self.last_viewed_at = Time.now
    save
  end
  
  private
  
  def increase_view_count
    self.view_count = 0 if self.view_count.blank?
    self.view_count += 1
  end
end
