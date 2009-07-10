require 'test_helper'

class CreativeDashboard < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Creative.make(:password => "testing")
      login_as(@creative)
      
      @brief = Brief.make(:published)
      
      Brief.stubs(:search).returns([@brief])
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

      context "page layout" do
        should "have basic search items" do
          assert_select 'form[action=?]', browse_briefs_path do
            assert_select 'input[name=?]', "q"
            assert_select 'input[type=submit][value=?]', "Search"
          end
        end
      end
      
      context "searching" do
        
        context "search box" do
          setup do
            @search_term = @brief.title.split.rand    
            fill_in 'q', :with => @search_term
            click_button 'Search'
          end

          should "foo" do          
            assert_contains(assigns['search_results'], @brief)
          end
        end
            
      end
         
      
        # should_assign_to :current_objects
        # should_respond_with :success
        # should_render_template :browse
        
        # should "display briefs" do
        #   assert_contain(@brief.title)
        # end
      end
      
  end

end
