require 'test_helper'

class AuthorBriefQuestions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "author" do
    
    setup do
      @author = Author.make(:password => "testing")
      login_as(@author)
    
      @brief = Brief.make(:published, { :author => @author })
      @creative = Creative.make
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
        populate_brief(@brief)
        
        5.times do
          @brief.creative_questions.make(:brief_item => @brief.brief_items.first, :creative => @creative)
        end
        
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
      
      should "not provide a link to create a new question" do
        assert_not_contain('Ask a question')
      end
      
      context "question filters" do
        setup do
          @filters = %w(hot answered)
        end
      
        should "provide links to each exposed filter" do
          @filters.each do |f|
            click_link f
            assert_response :success
            assert_equal(eval("#{f}_brief_creative_questions_path(@brief)"), path)
          end
        end
        
        should "provide link to recent questions" do
          visit hot_brief_creative_questions_path(@brief)
          click_link 'recent'
          assert_response :success
          assert_equal(brief_creative_questions_path(@brief), path)
        end
        
      end
      
      context "question widget" do
        setup do
          @question = @brief.creative_questions.first
          @answer = "Yes my child"
        end
      
        context "unanswered question" do
          should "provide a form to answer the question" do
            assert_select 'li.creative_question', :id => "creative_question_#{@question}" do
              
              assert_select "form[action=?]", brief_creative_question_path(@brief, @question) do
                fill_in 'creative_question_author_answer', :with => @answer
                click_button 'submit answer'
              end

              assert_response :success
              assert_equal(brief_creative_questions_path, path)
              assert_contain(@answer)
            end
          end
        end
        
        context "answered question" do
          setup do
            @question.author_answer = "Some answer"
            @question.save
            
            reload
            assert @question.answered?
          end
      
          should "display the answer" do
            assert_select 'li.creative_question', :id => "creative_question_#{@question}" do
              assert_select 'p', :text => @question.author_answer
            end
          end
        end
      
      end
          
      context "inline ask question form" do
        should "not have form inline to add questions" do
          assert_select "form[action=?]", brief_creative_questions_path, :count => 0
        end
      end

    end
  end
end