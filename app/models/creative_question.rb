class CreativeQuestion < ActiveRecord::Base
  belongs_to :brief_answer
  belongs_to :creative
  
  validates_presence_of :brief_answer, :creative, :body
  
  def love!
    update_attribute(:love_count, love_count + 1)
  end
  
  def hate!
    update_attribute(:hate_count, hate_count + 1)
  end
  
  named_scope :answered, :conditions => "answer NOT NULL"
  
end
