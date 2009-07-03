require 'test_helper'

class CreativeDashboard < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
    end
    
    context "general" do
      setup do
        visit briefs_path
      end

      should "have page title" do
        within '.title_holder' do |scope|
          assert_select 'h2', :text => "Dashboard"
        end
      end
    end
    
    context "activity snapshot" do
      setup do
        
      end
      
      should "notify when a brief is due to close submissions"
      should "notify of a brief that requires peer review"
      should "notify when a question has been answered"
      should "display a list of recent activity on all other briefs"
    end

    context "watched briefs" do
      setup do
        @brief = Brief.make(:published)
        @creative.watch(@brief)        
        
        reload
      end

      should "not show blank text" do
        # assert_not_contain("You aren't involved with any briefs yet, try searching above.")
      end
      
      should "display list if any watched briefs exist" do
        assert !@creative.briefs.empty?
        assert_equal(@creative.briefs, assigns['current_objects'])
        assert_select 'h4', :text => 'Watching'
      end
      
    end
    
    context "pitches" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
    context "search and brief categories" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
  end

end
