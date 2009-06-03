class CreativeQuestion < ActiveRecord::Base
  belongs_to :brief
  belongs_to :creative
  
  validates_presence_of :brief, :creative, :body
  
  def love!
    update_attribute(:love_count, love_count + 1)
  end
  
  def hate!
    update_attribute(:hate_count, hate_count + 1)
  end
  
end
