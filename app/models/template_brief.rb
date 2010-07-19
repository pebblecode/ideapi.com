class TemplateBrief < ActiveRecord::Base
  belongs_to :site
  has_many :template_brief_questions, :order => 'position', :dependent => :destroy
  has_many :template_questions, :through => :template_brief_questions, :order => 'template_brief_questions.position' 
  
  has_many :account_template_briefs
  has_many :accounts, :through => :account_template_briefs

  accepts_nested_attributes_for :template_questions, 
    :reject_if => proc { |attrs| attrs['optional'] == '0' && attrs['is_heading'] == '0' && attrs['body'].blank? },
    :allow_destroy => true
  



  class << self
    def default
      first(:conditions => ["template_briefs.default = ?", true])
    end

  end
    
  named_scope :available_for_account, lambda { |account| { 
      :include => :account_template_briefs,
      :conditions => ["template_briefs.id NOT IN (SELECT account_template_briefs.template_brief_id from account_template_briefs WHERE account_template_briefs.account_id = ?)", account] 
    }
  }
  
  
  named_scope :owned_templates, lambda { |account| { 
      :include => :account_template_briefs,
      :conditions => ["template_briefs.id IN (SELECT account_template_briefs.template_brief_id from account_template_briefs WHERE account_template_briefs.account_id = ?) and template_briefs.default = 0", account] 
    }
  }
end
