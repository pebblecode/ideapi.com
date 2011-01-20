class TemplateQuestion < ActiveRecord::Base
  has_many :template_document_questions, :dependent => :destroy
  has_many :template_documents, :through => :template_document_questions
  belongs_to :template_section

  def section_name
    template_section.title
  end
    
  named_scope :available_for_template, lambda { |template_document| { 
      :include => :template_document_questions,
      :conditions => ["template_questions.id NOT IN (SELECT template_document_questions.template_question_id from template_document_questions WHERE template_document_questions.template_document_id = ?)", template_document] 
    }
  }
  
  validates_presence_of :body
end
