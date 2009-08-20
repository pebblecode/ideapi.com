require 'test_helper'

class GeneralBriefAssumptions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "general briefs on the website" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")
      @published = Brief.make(:published, :user => @author)
      @draft = Brief.make
    end

    context "standard user" do
      setup do
        login_as(@standard_user)
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a published brief" do
          setup do
            visit brief_path(@published)
          end

          should_respond_with :success
          should_render_template :show

          should "be viewing brief" do        
            assert_equal(brief_path(@published), path)
          end
        end

        context "viewing a draft brief" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end
        
        context "viewing a published brief with questions" do
          setup do
            populate_brief(@published)
            
            @published.reload
            
            @user_question = @published.questions.make(:brief_item => @published.brief_items.first, :user => @standard_user)
            @other_answered_question = @published.questions.make(:answered, { :brief_item => @published.brief_items.first, :user => User.make })
            @other_unanswered_question = @published.questions.make(:brief_item => @published.brief_items.first, :user => User.make)
            
            visit brief_path(@published)
          end

          should "show answered questions" do
            assert_contain(@other_answered_question.body)
          end
          
          should "show users unanswered questions" do
            assert_contain(@user_question.body)
          end
          
          should "show users unanswered questions" do
            assert_not_contain(@other_unanswered_question.body)
          end
          
        end
        
      end

    end

    context "brief author" do
      setup do
        login_as(@author)
      end

      context "when logged in" do

        setup do
          visit briefs_path
        end

        should_respond_with :success
        should_render_template :index

        should "be viewing briefs" do        
          assert_equal(briefs_path, path)
        end

        context "viewing a draft brief that isnt their own" do
          setup do
            visit brief_path(@draft)
          end

          should_respond_with :success
          should_render_template :index

          should "be viewing brief" do        
            assert_equal(briefs_path, path)
          end
        end

      end  

    end

  end
  
end