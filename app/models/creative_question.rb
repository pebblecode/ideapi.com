class CreativeQuestion < ActiveRecord::Base
  belongs_to :creative
  belongs_to :brief
  belongs_to :brief_item

  named_scope :hot, :order => "updated_at DESC"
  named_scope :answered, :conditions => ["author_answer != ?", ""], :order => "updated_at DESC"
  
  validates_presence_of :brief_item_id, :brief_item, :creative_id
  
  def answered?
    !author_answer.blank?
  end
  
end
