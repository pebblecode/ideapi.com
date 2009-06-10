require 'test_helper'

class ViewingAnActiveBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "all users" do
    
    setup do
      # we dont care what type of user
      @user = User.make(:password => "testing")
      login_as(@user)
      
      @template = make_brief_template
      
      @brief = Brief.make(:brief_template => @template)

      @brief.brief_answers.each do |answer|
        answer.update_attribute(:body, "Stubbed answer to #{answer.brief_question.title}")
      end

      @brief.publish!
    end
    
    should "mock out brief template properly" do
      assert_equal(mock_amount, @template.brief_sections.count)
      assert_equal(mock_amount, @template.brief_sections.first.brief_questions.count)
      assert_equal(@template.brief_sections.count, @brief.brief_sections.count)      
    end

    should "be able to view a brief" do
      visit brief_path(@brief)
      assert_response :success
      assert_equal(brief_path(@brief), path)
    end
    
    context "linking to questions to brief item" do
      
      setup do
        @brief_answer = @brief.brief_answers.first
        @creative_question = CreativeQuestion.make(:brief_answer => @brief_answer)
        
        visit brief_path(@brief)
      end
    
      should "have general ask a question link" do
        assert_contain("ask a question")
        click_link("ask a question")
        assert_response :success
        assert_equal(brief_creative_questions_path(@brief), path)
      end
      
      should "have specific ask a question links tied to a brief item" do
        assert_have_selector("a", :href => brief_creative_questions_path(@brief, :response_to => @creative_question.id))
      end
      
      should "have question count for each brief item" do
        count = @brief_answer.creative_questions.count
        
        assert_have_selector("div#brief_answer_#{@brief_answer.id}")
        
        within "div#brief_answer_#{@brief_answer.id}" do |scope|
          scope.click_link "#{count} questions"
          assert_response :success
          assert_equal(brief_creative_questions_path(@brief, :response_to => @creative_question.id), path)       
        end
      end
      
      context "answered question" do
        setup do
          @creative_question = CreativeQuestion.make(:brief_answer => @brief_answer, :answer => "boom boom")
          visit brief_path(@brief)
        end

        should "show any author answers to a question linked to a brief item" do
          assert_contain("boom boom")
        end
      end
      
    end
    
  end
  
  # context "author" do
  #   setup do
  #     
  #   end
  # 
  #   should "description" do
  #     
  #   end
  # end
  # 
  # context "creative" do
  #   setup do
  #     
  #   end
  # 
  #   should "description" do
  #     
  #   end
  # end

end
