require 'test_helper'

class BriefTest < ActiveSupport::TestCase
  
  should_belong_to :author
  should_belong_to :template_brief
  
  should_have_many :brief_items
  should_have_many :creative_questions
  
  should_validate_presence_of :author_id, :template_brief_id, :title
  
  
  # context "BriefQuestions and Answer relationship" do
  #   
  #   setup do
  #     @template_brief = TemplateBrief.make
  #     @section = BriefSection.make(:assign_template_brief => @template_brief)
  #     
  #     @number_of_questions = 5
  #     @number_of_questions.times { BriefQuestion.make(:assign_brief_section => @section) }
  #     assert_equal(@number_of_questions, @section.brief_questions.count)
  #     
  #     @brief = Brief.make(:template_brief => @template_brief)
  #   end
  # 
  #   should "get brief_sections from brief config" do
  #     assert_equal(@template_brief.brief_sections.count, @brief.brief_sections.count)
  #   end
  #   
  #   should "have generate template brief_answers for questions" do
  #     assert(@brief.respond_to?(:generate_template_brief_answers!), "Brief should respond to 'generate_template_brief_answers!'")
  #     assert(!@brief.brief_answers.blank?, "brief_answers should not be blank")
  #     assert_equal(@number_of_questions, @brief.brief_answers.count)
  #   end
  #   
  #   should "not duplicate brief_answers for questions when generator is run" do
  #     assert(!@brief.brief_answers.blank?, "brief_answers should not be blank")
  #     assert_equal(@number_of_questions, @brief.brief_answers.count)
  #     assert(@brief.generate_template_brief_answers!, "template brief_answer creation failed")
  #     assert_equal(@number_of_questions, @brief.brief_answers.count)
  #   end
  #   
  #   context "find brief_answer by question and section" do
  #     
  #     should "respond to brief_answer_for" do 
  #       assert @brief.respond_to?(:brief_answer_for) 
  #     end
  #     
  #     should "find the brief_answer" do
  #       brief_answer = @brief.brief_answers.first  
  #       assert_equal brief_answer, @brief.brief_answer_for(brief_answer.brief_question, brief_answer.brief_section)
  #     end
  #     
  #     should "create an brief_answer if none exists" do
  #       section = BriefSection.make
  #       question = BriefQuestion.make(:assign_brief_section => section)
  #       
  #       #assert_equal brief_answer, @brief.brief_answer_for(question, section)
  #     end
  #   
  #   end 
  #           
  # end
  
  context "state machine" do
    setup do
      @brief = Brief.make
    end
  
    should "start with draft state" do
      assert_equal(:draft, @brief.state)
    end
    
    should "be able to be published" do
      assert(@brief.respond_to?(:publish!), "Should respond to publish!")
    end
    
    context "publishing" do
      setup do
        @brief.publish!
      end
  
      should "be published" do
        assert_equal(:published, @brief.state)
      end
      
      should "respond to close!" do
        assert @brief.respond_to?(:close!)
      end
      
      should "be able to be closed" do
        @brief.close!
        assert_equal(:closed, @brief.state)
      end
  
      should "respond to review!" do
        assert @brief.respond_to?(:review!)
      end
      
      context "peer review" do
        setup do
          @brief.review!
        end
      
        should "be able to put into review" do
          assert_equal(:peer_review, @brief.state)
        end
  
        should "be able to be closed" do
          @brief.close!
        end
      end
  
    end
    
     context "persistance" do
       setup do
         @brief.publish!
       end
   
       should "be published when reloaded" do
         assert_equal(:published, @brief.state)
         @brief.reload
         assert_equal(:published, @brief.state)
       end
     end
       
  end
  
  
end
