class Question < ActiveRecord::Base
  belongs_to :user
  belongs_to :brief
  belongs_to :brief_item, :touch => true
  
  named_scope :recent, :order => "updated_at DESC"
  named_scope :answered, :conditions => ["author_answer != ?", ""], :order => "updated_at ASC"
  named_scope :unanswered, :conditions => ["author_answer IS NULL"], :order => "created_at ASC"
  
  validates_presence_of :brief_id, :user_id
  
  validates_presence_of :brief_item_id, :message => "Please select the brief section to which you are responding."
  
  before_validation :ensure_brief_present
  
  def answered?
    !author_answer.blank?
  end
  
  def answer_author
    brief.author if answered? && brief.present?
  end
  
  attr_reader :recently_answered
  
  def author_answer=(answer)
    @recently_answered = true
    self['author_answer'] = answer
  end
  
  def updated_on
    updated_at.to_date
  end
  
  include Ideapi::GetParsed
  gp_parse_fields :author_answer, :body
  
  class << self
    def brief_items
      all(:group => :brief_item_id, :include => :brief_item).map(&:brief_item)
    end
  end
  
  fires :new_question, :on => :create,
                       :actor => :user,
                       :secondary_subject  => 'brief_item', 
                       :log_level => 1
  
  fires :question_answered, :on => :update,
                            :actor => 'answer_author',
                            :secondary_subject  => 'brief_item',
                            :if => lambda { |question| (question.answered? && question.recently_answered) }, 
                            :log_level => 1
  
  private
  
  def ensure_brief_present
    self.brief = brief_item.brief if brief_item.present? && brief.blank?
  end

end