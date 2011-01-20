class TemplateDocument < ActiveRecord::Base
  belongs_to :site
  has_many :template_document_questions, :order => 'position', :dependent => :destroy
  has_many :template_questions, :through => :template_document_questions, :order => 'template_document_questions.position' 
  
  has_many :account_template_documents
  has_many :accounts, :through => :account_template_documents

  accepts_nested_attributes_for :template_questions, 
    :reject_if => proc { |attributes| attributes['body'].blank? && attributes['help_message'].blank? }, 
    :allow_destroy => true
  
  attr_accessible :title, :template_questions_attributes


  class << self
    def default
      first(:conditions => ["template_documents.default = ?", true])
    end

  end
    
  named_scope :available_for_account, lambda { |account| { 
      :include => :account_template_documents,
      :conditions => ["template_documents.id NOT IN (SELECT account_template_documents.template_document_id from account_template_documents WHERE account_template_documents.account_id = ?)", account] 
    }
  }
  
  
  named_scope :owned_templates, lambda { |account| { 
      :include => [:account_template_documents, :template_questions],
      :conditions => ["template_documents.id IN (SELECT account_template_documents.template_document_id from account_template_documents WHERE account_template_documents.account_id = ?) and template_documents.default = 0", account] 
    }
  }
end
