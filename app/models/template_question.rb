class TemplateQuestion < ActiveRecord::Base
  has_many :template_brief_questions, :dependent => :destroy
  has_many :template_briefs, :through => :template_brief_questions
  belongs_to :template_section

  def section_name
    template_section.title
  end
    
  named_scope :available_for_template, lambda { |template_brief| { 
      :include => :template_brief_questions,
      :conditions => ["template_questions.id NOT IN (SELECT template_brief_questions.template_question_id from template_brief_questions WHERE template_brief_questions.template_brief_id = ?)", template_brief] 
    }
  }
  
  validates_presence_of :body
end
