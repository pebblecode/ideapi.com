require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  
  #fixtures :users, :brief_configs

  context "Questions and Answer relationship" do
    
    setup do
      @brief_config = BriefConfig.make
      @section = Section.make(:brief_config => @brief_config)
      
      @number_of_questions = 5
      @number_of_questions.times { Question.make(:assign_section => @section) }
      assert_equal(@number_of_questions, @section.questions.count)
      
      @brief = Brief.make(:brief_config => @brief_config)
    end

    should "get sections from brief config" do
      assert_equal(@brief_config.sections.count, @brief.sections.count)
    end
    
    should "have generate template answers for questions" do
      assert(@brief.respond_to?(:generate_template_answers!), "Brief should respond to 'generate_template_answers!'")
      assert(@brief.answers.blank?)
      assert(@brief.generate_template_answers!, "template answer creation failed")
      assert_equal(@number_of_questions, @brief.answers.count)
    end
    
    should "not duplicate answers for questions when generator is run" do
      assert(@brief.answers.blank?)
      assert(@brief.generate_template_answers!, "template answer creation failed")
      assert_equal(@number_of_questions, @brief.answers.count)
      assert(@brief.generate_template_answers!, "template answer creation failed")
      assert_equal(@number_of_questions, @brief.answers.count)
    end
        
  end
  
end
