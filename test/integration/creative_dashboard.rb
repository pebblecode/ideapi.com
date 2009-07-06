require 'test_helper'

class CreativeDashboard < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
    
      @brief = Brief.make(:published)
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
        @creative.watch(@brief)                
        reload
      end

      should "not show blank text" do
        assert_not_contain("You aren't involved with any briefs yet, try searching above.")
      end
      
      should "display list if any watched briefs exist" do
        assert !@creative.briefs.empty?
        assert_equal(@creative.briefs, assigns['current_objects'])
        assert_select 'h4', :text => 'Watching'
        assert_select 'ul.watching' do
          @creative.watching.each do |brief|            
            assert_select "li#brief_#{brief.id}" do
              assert_select 'a', :href => brief_path(brief), :text => brief.title
            end
          end
        end
      end
      
    end
    
    context "pitches" do
      setup do
        @creative.respond_to_brief(@brief)
        reload
      end

      should "display list of active pitches" do
        assert_select 'h4', :text => 'Watching', :count => 0
        assert_select 'h4', :text => 'Pitching'
        assert_select 'ul.pitching' do
          @creative.pitching.each do |brief|            
            assert_select "li#brief_#{brief.id}" do
              assert_select 'a', :href => brief_path(brief), :text => brief.title
            end
          end
        end
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
