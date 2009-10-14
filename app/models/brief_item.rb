class BriefItem < ActiveRecord::Base

  # RELATIONS
  belongs_to :brief
  belongs_to :template_question
  
  has_many :questions
  has_many :timeline_events, :as => :secondary_subject, :order => 'created_at DESC'
  
  # VALIDATIONS
  validates_presence_of :brief, :template_question
  
  # DELEGATIONS
  delegate :optional, :to => :template_question
  delegate :help_message, :to => :template_question
  delegate :section_name, :to => :template_question
  delegate :published?, :to => :brief
  delegate :author, :to => :brief
  
  # NAMED SCOPES
  named_scope :answered, :conditions => 'body <> ""'
  
  # VERSION MANAGEMENT
  acts_as_versioned :if_changed => [:body]
  
  def version_condition_met? # totally bypasses the <tt>:if</tt> option
    self.published? && self.body.present?
  end
  
  self.non_versioned_columns << 'updated_at'
  self.non_versioned_columns << 'created_at'
  
  delegate :latest, :to => :revisions
  
  fires :brief_item_changed, :on => :update,
                             :actor => 'author',
                             :subject => 'latest',
                             :secondary_subject  => :self,
                             :log_level => 1,
                             :if => lambda { |question| question.latest.present? }

  class Version
    
    named_scope :revisions, 
      lambda { |brief_item| 
        { 
          :conditions => [
            "version > 1 AND body <> '' AND brief_item_id = ?", 
            brief_item.id
          ] 
        }
      } do      
      
      # METHODS SCOPED INSIDE REVISIONS
      def latest
        self.last
      end

    end
    
    include Ideapi::GetParsed
    gp_parse_fields :body
    
  end
  
  def revisions
    Version.revisions(self)
  end
  
  # FORMATTING
  include Ideapi::GetParsed
  gp_parse_fields :body
  truncates :title
      
end
