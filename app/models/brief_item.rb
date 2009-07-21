class BriefItem < ActiveRecord::Base
  belongs_to :brief
  belongs_to :template_question
  
  has_many :creative_questions
  
  validates_presence_of :brief, :template_question, :on => :create, :message => "can't be blank"
  
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  delegate :published?, :to => :brief
  
  named_scope :answered, :conditions => 'body <> ""'
  
  acts_as_versioned :if => :published?, :if_changed => [:body]
  
  def has_history?
    !creative_questions.answered.blank?
  end
  
  def history
    # grab all revisions minus the current one..
    revisions = versions.all(:conditions => ['version < ?', self.version])
    
    # sort by latest first ..
    (creative_questions.answered + revisions).sort {|a,b| b.updated_at <=> a.updated_at }
  end

end
