require 'test_helper'

class AuthorDashboard < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "author" do
    setup do
      @author = Author.make(:password => "testing")
      login_as(@author)
    end

    context "general" do
      setup do
        visit briefs_path
      end

      should_respond_with :success
      should_render_template :index_author
    end
    

    context "first visit" do
      setup do
        visit briefs_path
      end

      should "get dashboard" do
        assert_equal briefs_path, path
      end
      
      should "have no briefs" do
        assert @author.briefs.empty?
      end
      
      should "have link to create a brief" do
        assert_contain "create brief"
      end
      
      should "explain activity snapshot" do
        within '.required_actions' do |scope|
          assert_contain("Once you have created some briefs, any outstanding actions you need to perform will be listed here")
        end
      end
      
      should "tell user that they have no briefs yet" do
        assert_contain "You don't have any briefs yet"
      end
      
    end
    
    context "displaying brief lists" do
      setup do
        @draft = Brief.make(:author => @author)
        assert @author.briefs.draft.include?(@draft)
        
        reload
      end

      should "show the list of briefs under heading" do
        assert_contain("Draft brief")
        within ".draft" do |scope|
          scope.click_link @draft.title
          assert_response :success
          assert_equal brief_path(@draft), path
        end
      end
    
      context "published briefs" do
        setup do
          @published = Brief.make(:author => @author)
          populate_brief(@published)
          @published.publish!
          assert @author.briefs.published.include?(@published)
          reload
        end

        should "show published briefs under heading" do
          assert_contain("Published briefs")
          within '.published' do |scope|
            scope.click_link @published.title
            assert_response :success
            assert_equal brief_path(@published), path
          end
        end
      end
      
    end
    
    
  end
  
end