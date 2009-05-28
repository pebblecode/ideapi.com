class Question < ActiveRecord::Base
  belongs_to :response_type
  has_many :section_questions
  
  has_many :sections, :through => :section_questions
  
  def assign_section(section)
    self.sections << section
  end

  alias :assign_section= :assign_section

end
