require 'test_helper'

class CreativeBriefQuestions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
    
      @brief = Brief.make(:published)
    end
    
    context "path from show brief" do
      setup do
        visit brief_path(@brief)
      end

      should "link to questions page" do
        click_link 'questions'
        assert_response :success
        assert_equal brief_creative_questions_path(@brief), path
      end
    end
    
    context "questions index" do
      setup do
        
        @brief.creative_questions.make
        
        visit brief_creative_questions_path(@brief)
        assert_response :success
        assert_equal brief_creative_questions_path(@brief), path
      end
      
      should "have title" do
        assert_select 'h2', :text => "Questions for #{@brief.title}"
      end
      
      should "should display the questions" do
        assert !@brief.creative_questions.blank?
        @brief.creative_questions.each do |question|
          assert_contain(question.body)
        end
      end
    end
    
  end
  
end