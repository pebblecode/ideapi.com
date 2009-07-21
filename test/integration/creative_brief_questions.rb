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
        click_link 'Brief discussion'
        assert_response :success
        assert_equal brief_creative_questions_path(@brief, :q => 'recent'), path
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
      
      should "should display the questions" do
        assert !@brief.creative_questions.blank?
        @brief.creative_questions.each do |question|
          assert_contain(question.body)
        end
      end
      
      context "question filters" do
        setup do
          @filters = %w(unanswered answered)
        end

        should "provide links to each exposed filter" do
          @filters.each do |f|
            click_link f
            assert_response :success
            assert_equal(eval("brief_creative_questions_path(@brief, :q => '#{f}')"), path)
          end
        end
        
        should "provide link to recent questions" do
          visit brief_creative_questions_path(@brief, :q => 'answered')
          click_link 'recent'
          assert_response :success
          assert_equal(brief_creative_questions_path(@brief, :q => 'recent'), path)
        end
        
      end
      
      context "question widget" do
        setup do
          @question = @brief.creative_questions.first
        end
 
        context "answered question" do
          setup do
            @question.author_answer = "Some answer"
            @question.save
            
            reload
            assert @question.answered?
          end

          should "display link to the answer" do
            assert_select '.author_answer' do
              assert_select 'p', :text => /#{@question.author_answer}/
            end
          end
        end

      end
    
      context "inline ask question form" do
        
        setup do
          @brief_item = @brief.brief_items[rand(@brief.brief_items.count)]
          @question = "Sha la la, from you to meeee, oh."
          reload
        end
        
        should "have form inline to add questions" do
          assert_select 'form[action=?]', brief_creative_questions_path 
        end
                    
        context "submitting the form" do
          setup do
            select @brief_item.title, :from => 'creative_question[brief_item_id]'
            fill_in 'creative_question_body', :with => @question
            click_button 'submit question'
          end

          should_respond_with :success
          
          should "show questions view" do
            assert_equal(brief_creative_questions_path, path)
          end
          
          should "show the asked question on the page" do
            assert_contain(@question)
          end
          
          should "watch the brief" do
            assert @creative.watching?(@brief)
          end

        end
        
      end
            
    end
  end
end