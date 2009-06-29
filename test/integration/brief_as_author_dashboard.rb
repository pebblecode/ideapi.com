require 'test_helper'

class BriefAsAuthorDashboard < ActionController::IntegrationTest
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

      should "have page title" do
        within '.title_holder' do |scope|
          assert_contain('Dashboard')
        end
      end
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
        assert_contain "Create Brief"
      end
      
      should "explain activity snapshot" do
        within '.required_actions' do |scope|
          assert_contain("Once you have created some briefs, any outstanding actions you need to perform will be listed here")
        end
      end
      
      should "tell user that they have no briefs yet" do
        assert_contain "Brief Overviews"
        assert_contain "You don't have any briefs yet"
      end
      
    end
      
  end
  
end