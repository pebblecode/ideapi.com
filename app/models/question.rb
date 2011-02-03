class Question < ActiveRecord::Base

  attr_accessor :send_notifications  
  before_destroy :delete_timeline_events
  
  belongs_to :user
  belongs_to :answered_by, :class_name => "User"
  
  belongs_to :document
  belongs_to :document_item, :touch => true
  
  named_scope :recent, :order => "updated_at DESC"
  named_scope :answered, :conditions => ["author_answer != ?", ""], :order => "updated_at ASC"
  named_scope :unanswered, :conditions => ["author_answer IS NULL"], :order => "created_at ASC"
  
  validates_presence_of :document_id, :user_id
  validates_presence_of :body, :message => "You didn't ask a question"
  validates_presence_of :document_item_id, :message => "Please select the document section to which you are responding."
  
  
  before_validation :ensure_document_present
  
  def answered?
    author_answer.present?
  end
  
  def updated_on
    updated_at.to_date
  end
  
  # include Ideapi::GetParsed
  # gp_parse_fields :author_answer, :body
  
  class << self
    def document_items
      all(:group => :document_item_id, :include => :document_item).map(&:document_item)
    end
  end
  
  fires :new_question, :on => :create,
                       :actor => :user,
                       :secondary_subject  => 'document_item', 
                       :log_level => 1
  
  fires :question_answered, :on => :update,
                            :actor => :answered_by,
                            :secondary_subject => :document_item,
                            :if => lambda { |question| (question.answered? && question.author_answer_changed?) }, 
                            :log_level => 1
  
  
  after_create :notify_document_users
  after_update :notify_if_question_answered
  
  after_save   :update_document
  
  
  private
  
  def ensure_document_present
    self.document = document_item.document if document_item.present? && document.blank?
  end
  
  def notify_if_question_answered
    # [DEPRECATED]
    # NotificationMailer.deliver_user_question_answered_on_document(self) if author_answer_changed? and self.author_answer.present?
    # We are using Resque to deliver emails so need to pass
    # the object id so the worker can do its thang
    begin
      NotificationMailer.deliver_user_question_answered_on_document(self.id) if author_answer_changed? and self.author_answer.present?
    rescue
      nil
    end
  end
  
  def notify_document_users
    # [DEPRECATED]
    # NotificationMailer.deliver_new_question_on_document(self, recipients) if recipients.present?
    # We are using Resque to deliver emails so need to pass
    # the object id so the worker can do its thang
    begin
      NotificationMailer.deliver_new_question_on_document(self.id, recipients) if recipients.present?
    rescue
      nil
    end
  end
  
  def recipients
    self.document.authors.collect{ |user| user.email unless user.pending? }.compact - [self.user.email]
  end
  
  def delete_timeline_events
    TimelineEvent.find(:all, :conditions => { :subject_id => self.id, :subject_type => self.class.to_s}).each do |event|
      event.destroy
    end
  end
  
  def update_document
    self.document.updated_at = Time.now
    self.document.save false
  end
  
end
