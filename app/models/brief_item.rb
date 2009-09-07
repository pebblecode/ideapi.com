class BriefItem < ActiveRecord::Base
  belongs_to :brief
  belongs_to :template_question
  
  has_many :questions
  
  validates_presence_of :brief, :template_question
  
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  delegate :published?, :to => :brief
  
  named_scope :answered, :conditions => 'body <> ""'
  
  acts_as_versioned :if => :published?, :if_changed => [:body]
  
  self.non_versioned_columns << 'updated_at'
  self.non_versioned_columns << 'created_at'
  
  truncates :title
  
  include Ideapi::GetParsed
  gp_parse_fields :body
    
  def has_history?(user = nil)
    brief_item_history(user).present?
  end
  
  def history(user = nil)
    if has_history?(user)
      # sort by latest first ..
      brief_item_history.sort {|a,b| b.updated_at <=> a.updated_at }
    else
      []
    end
  end
  
  def answered_questions
    questions.answered
  end
  
  def revisions
    # grab all revisions minus the current one..
    revisions = versions.all(:conditions => ["version < ? AND body <> ''", self.version])
  end
  
  def history_grouped_by_fancy_date(&block)
    history_items = block_given? ? yield : history 
    history_items.group_by do |item| 
      convert_datetime_into_relevant_precision(item.updated_at) 
    end
  end
  
  def history_grouped_by_fancy_date_including_user(user)
    history_grouped_by_fancy_date { history(user) }
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
  
  def brief_item_history(user = nil)
    @brief_item_history ||= (
      answered_questions + revisions + user_questions(user)
    )
  end

  def user_questions(user = nil)
    #user.present? ? user.questions.unanswered(:conditions => ["brief_item_id = ?", self.id]) : []
    []
  end
  
end
