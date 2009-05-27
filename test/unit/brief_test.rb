require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  
  #fixtures :users, :brief_configs

  context "Questions and Answer relationship" do
    setup do
      @brief = Brief.make
      assert(@brief.answers.blank?, "Brief should have no answers")
      
      @section = Section.make
      @number_of_questions = 5
      @number_of_questions.times { Question.make(:section => @section) }
      @brief.sections << @section
      
      assert(!@brief.sections.blank?, "Brief should have some sections")
    end

    should "have questions available from current config" do
      
    end
  end
  

end
