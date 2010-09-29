class Question < ActiveRecord::Base
  
  before_destroy :delete_timeline_events
  
  belongs_to :user
  belongs_to :answered_by, :class_name => "User"
  
  belongs_to :brief
  belongs_to :brief_item, :touch => true
  
  named_scope :recent, :order => "updated_at DESC"
  named_scope :answered, :conditions => ["author_answer != ?", ""], :order => "updated_at ASC"
  named_scope :unanswered, :conditions => ["author_answer IS NULL"], :order => "created_at ASC"
  
  validates_presence_of :brief_id, :user_id
  
  validates_presence_of :brief_item_id, :message => "Please select the brief section to which you are responding."
  
  before_validation :ensure_brief_present
  
  def answered?
    author_answer.present?
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
                            :actor => :answered_by,
                            :secondary_subject => :brief_item,
                            :if => lambda { |question| (question.answered? && question.author_answer_changed?) }, 
                            :log_level => 1
  
  
  after_create :notify_brief_users
  after_update :notify_if_question_answered
  
  after_save   :update_brief
  
  
  private
  
  def ensure_brief_present
    self.brief = brief_item.brief if brief_item.present? && brief.blank?
  end
  
  def notify_if_question_answered
    # [DEPRECATED]
    # NotificationMailer.deliver_user_question_answered_on_brief(self) if author_answer_changed? and self.author_answer.present?
    # We are using Resque to deliver emails so need to pass
    # the object id so the worker can do its thang
    NotificationMailer.deliver_user_question_answered_on_brief(self.id) if author_answer_changed? and self.author_answer.present?
  end
  
  def notify_brief_users
    # [DEPRECATED]
    # NotificationMailer.deliver_new_question_on_brief(self, recipients) if recipients.present?
    # We are using Resque to deliver emails so need to pass
    # the object id so the worker can do its thang
    NotificationMailer.deliver_new_question_on_brief(self.id, recipients) if recipients.present?
  end
  
  def recipients
    self.brief.authors.collect{ |user| user.email unless user.pending? }.compact - [self.user.email]
  end
  
  def delete_timeline_events
    TimelineEvent.find(:all, :conditions => { :subject_id => self.id, :subject_type => self.class.to_s}).each do |event|
      event.destroy
    end
  end
  
  def update_brief
    self.brief.updated_at = Time.now
    self.brief.save false
  end
  
end
