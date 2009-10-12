class BriefItem < ActiveRecord::Base

  # RELATIONS
  belongs_to :brief
  belongs_to :template_question
  
  has_many :questions
  has_many :timeline_events, :as => :secondary_subject
  
  # VALIDATIONS
  validates_presence_of :brief, :template_question
  
  # DELEGATIONS
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  delegate :published?, :to => :brief
  
  # NAMED SCOPES
  named_scope :answered, :conditions => 'body <> ""'
  
  # VERSION MANAGEMENT
  acts_as_versioned :if => :published?, :if_changed => [:body]
  self.non_versioned_columns << 'updated_at'
  self.non_versioned_columns << 'created_at'

  class Version
    named_scope :revisions, lambda { |brief_item|
      {:conditions => ["version < ? AND body <> ''", brief_item.version]}
    }
  end
  
  def revisions
    Version.revisions(self)
  end
  
  # FORMATTING
  include Ideapi::GetParsed
  gp_parse_fields :body
  truncates :title
      
end
