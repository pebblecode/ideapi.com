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
  
  def updated_on
    updated_at.to_date
  end
  
  include Ideapi::GetParsed
  parse_carriage_returns_on :author_answer, :body
  parse_links_to_html_on :author_answer, :body
  
  class << self
    def brief_items
      all(:group => :brief_item_id, :include => :brief_item).map(&:brief_item)
    end
  end

end