require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  
  context "BriefQuestions and Answer relationship" do
    
    setup do
      @brief_template = BriefTemplate.make
      @section = BriefSection.make(:assign_brief_template => @brief_template)
      
      @number_of_questions = 5
      @number_of_questions.times { BriefQuestion.make(:assign_brief_section => @section) }
      assert_equal(@number_of_questions, @section.brief_questions.count)
      
      @brief = Brief.make(:brief_template => @brief_template)
    end

    should "get brief_sections from brief config" do
      assert_equal(@brief_template.brief_sections.count, @brief.brief_sections.count)
    end
    
    should "have generate template brief_answers for questions" do
      assert(@brief.respond_to?(:generate_template_brief_answers!), "Brief should respond to 'generate_template_brief_answers!'")
      assert(!@brief.brief_answers.blank?, "brief_answers should not be blank")
      assert_equal(@number_of_questions, @brief.brief_answers.count)
    end
    
    should "not duplicate brief_answers for questions when generator is run" do
      assert(!@brief.brief_answers.blank?, "brief_answers should not be blank")
      assert_equal(@number_of_questions, @brief.brief_answers.count)
      assert(@brief.generate_template_brief_answers!, "template brief_answer creation failed")
      assert_equal(@number_of_questions, @brief.brief_answers.count)
    end
    
    context "find brief_answer by question and section" do
      
      should "respond to brief_answer_for" do 
        assert @brief.respond_to?(:brief_answer_for) 
      end
      
      should "find the brief_answer" do
        brief_answer = @brief.brief_answers.first  
        assert_equal brief_answer, @brief.brief_answer_for(brief_answer.brief_question, brief_answer.brief_section)
      end
      
      should "create an brief_answer if none exists" do
        section = BriefSection.make
        question = BriefQuestion.make(:assign_brief_section => section)
        
        #assert_equal brief_answer, @brief.brief_answer_for(question, section)
      end
    
    end 
            
  end
  
end
