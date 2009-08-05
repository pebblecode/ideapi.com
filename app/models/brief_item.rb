class BriefItem < ActiveRecord::Base
  belongs_to :brief
  belongs_to :template_question
  
  has_many :questions
  
  validates_presence_of :brief, :template_question, :on => :create, :message => "can't be blank"
  
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  delegate :published?, :to => :brief
  
  named_scope :answered, :conditions => 'body <> ""'
  
  acts_as_versioned :if => :published?, :if_changed => [:body]
  
  truncates :title
  
  def has_history?
    !questions.answered.blank? || !revisions.blank?
  end
  
  def history
    if has_history?
      # sort by latest first ..
      (answered_questions + revisions).sort {|a,b| b.updated_at <=> a.updated_at }
    else
      []
    end
  end
  
  def answered_questions
    questions.answered
  end
  
  def revisions
    # grab all revisions minus the current one..
    revisions = versions.all(:conditions => ['version < ?', self.version])
  end
  
  def history_grouped_by_fancy_date
    history.group_by {|item| convert_datetime_into_relevant_precision(item.updated_at) }
  end
  
  private
  
  def convert_datetime_into_relevant_precision(datetime)
    now = Time.now
    date_as_time = datetime.to_time #ensure its a time object..
    
    if ((now - date_as_time) < 1.day && now.day == date_as_time.day)
      key = date_as_time.to_i
    else
      key = date_as_time.to_date.to_time.to_i
    end
  end
  
end
