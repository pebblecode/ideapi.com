class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :brief
  belongs_to :brief_item

  named_scope :recent, :order => "updated_at DESC"
  named_scope :answered, :conditions => ["author_answer != ?", ""], :order => "updated_at ASC"
  named_scope :unanswered, :conditions => ["author_answer IS NULL"], :order => "created_at ASC"
  
  validates_presence_of :brief_item_id, :brief_item, :user_id
  
  def answered?
    !author_answer.blank?
  end

end