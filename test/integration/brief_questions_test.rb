require 'test_helper'

class BriefQuestionsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper
  
  context "" do
    setup do
      @author = User.make(:password => "testing")    
      @brief = Brief.make(:published, { :user => @author })
      @standard_user = User.make(:password => "testing")
    end
    
    context "visiting the discussion from a published brief (show action)" do

      context "when logged in as a standard user" do

        setup do
          login_as(@standard_user)
        end

        context "viewing a brief" do
          setup do
            visit brief_path(@brief)
          end

          should_respond_with :success
          should_render_template :show

          context "clicking brief discussion link" do
            setup { click_link 'start the discussion' }

            should_respond_with :success
            should_render_template :index

            should "link to unanswered questions as default" do
              assert_equal(brief_questions_path(@brief, :f => "unanswered"), path)
            end
          end

        end

      end

      context "when logged in as a brief author" do

        setup do
          login_as(@author)
        end

        context "and viewing a brief" do
          setup do
            visit brief_path(@brief)
          end

          should_respond_with :success
          should_render_template :show

          context "clicking brief discussion link" do
            setup { click_link 'start the discussion' }

            should_respond_with :success
            should_render_template :index

            context "as brief owner" do
              should "link to unanswered questions as default" do
                assert_equal(brief_questions_path(@brief, :f => "unanswered"), path)
              end
            end

          end
        end

      end

      # END CONTEXT BRIEF AUTHOR

    end

    context "questions index" do

      setup do
        populate_brief(@brief)

        5.times do
          @brief.questions.make(:brief_item => @brief.brief_items.first, :user => @standard_user)
        end
      end
      
      context "when logged in" do
        setup do
          login_as(@standard_user)
          
          visit brief_questions_path(@brief)
        end

        should_respond_with :success
        should_render_template :index

        should "have title" do
          assert_contain truncate(@brief.title.downcase, :length => 30)
        end

        context "questions" do
          should "brief should have questions" do
            assert !@brief.questions.blank?
          end

          should "should displayed" do
            @brief.questions.each do |question|
              assert_contain(question.body)
            end
          end
        end
        
        context "question filters" do
          setup do
            @filters = %w(Answered Unanswered)
          end

          should "provide links to each exposed filter" do
            @filters.each do |f|
              click_link f
              assert_response :success
              assert_equal(eval("brief_questions_path(@brief, :f => '#{f.downcase}')"), path)
            end
          end

          # because the default state would be 'recent'
          # we test this separately..

          should "provide link to recent questions" do
            visit brief_questions_path(@brief, :f => "unanswered")
            click_link 'recent'
            assert_response :success
            assert_equal(brief_questions_path(@brief, :f => "recent"), path)
          end

        end
        
        context "viewing answered questions" do
          setup do
            @question = @brief.questions.first
            @answer = "Yes my child"
          end
          
          context "when a question is answered" do
            setup do
              @question.author_answer = @answer
              @question.save
              
              visit brief_questions_path(@brief, :f => "answered")
            end

            should "question should have its state set to answered" do
              assert @question.answered?
            end

            should "display the answer" do
              assert_contain @question.author_answer
            end
          end
        end
        
      end

      context "when logged in as brief author" do
        setup { login_as(@author) }
        
        context "visiting questions index" do
          setup { visit brief_questions_path(@brief, :f => "unanswered") }
        
          should "not provide a link to create a new question" do
            assert_not_contain('Ask a question')
          end
          
          context "question widget" do
            setup do
              @question = @brief.questions.first
              @answer = "Yes my child"
            end

            context "unanswered question" do
              
              should "provide a form to answer the question" do
                assert_select "form[action=?]", brief_question_path(@brief, @question)
              end
              
              context "filling in the answer" do
                setup do
                  fill_in 'question_author_answer', :with => @answer
                  click_button 'question_submit'
                end
                
                should_respond_with :success
                
                should "redirect properly" do
                  assert_equal(brief_questions_path, path)
                end
                
                should "contain the answer" do
                  assert_contain(@answer)
                end

              end
              
            end
          
          end

          context "inline ask question form" do
            should "not have form inline to add questions" do
              assert_select "form[action=?][method=?]", brief_questions_path(@brief), 'post', :count => 0
            end
          end
          
        end
        
      end

      context "when logged in as standard user" do
        setup { login_as(@standard_user) }
        
        context "visiting questions index" do
          setup { visit brief_questions_path(@brief) }
          
          context "inline ask question form" do

            setup do
              @brief_item = @brief.brief_items[rand(@brief.brief_items.count)]
              @question = "Sha la la, from you to meeee, oh."
              reload
            end

            should "have form inline to add questions" do
              assert_select 'form[action=?][method=?]', brief_questions_path, 'post'
            end
            
            context "submitting the form" do
              setup do
                select @brief_item.title, :from => 'question[brief_item_id]'
                fill_in 'question_body', :with => @question
                click_button 'ask'
              end
            
              should_respond_with :success
            
              should "show questions view" do
                assert_equal(brief_questions_path, path)
              end
                          
              should "show the asked question on the page" do
                assert_contain(@question)
              end
                          
              should "watch the brief" do
                assert @standard_user.watching?(@brief)
              end
            
            end
            
          end
          
        end

      end

    end

  end
  
end