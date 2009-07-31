require 'test_helper'

class UserDashboardTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")
    end
    
    context "as any type of user" do
      setup do
        login_as(@standard_user)
        visit briefs_path
      end

      should_assign_to :current_objects
      should_respond_with :success
      should_render_template :index
    
      context "first visit" do
        setup do
          visit briefs_path
        end

        should "get dashboard" do
          assert_equal briefs_path, path
        end

        should "have no briefs" do
          assert @standard_user.briefs.empty?
        end

        should "tell user that they have no briefs yet" do
          assert_contain "You don't have any briefs yet"
        end
        
        should "have link to create a brief" do
          assert_contain "create brief"
        end
      end
      
      context "session data" do
        setup do
          @standard_user.reload
        end

        should "set last_request_at when logging in" do
          assert(!@standard_user.last_request_at.blank?)
        end
        
        should "have recent last_request_at after logging in" do
          assert((Time.now - @standard_user.last_request_at) < 1.minute)
        end
      end
      
       
    end
     
    context "as a brief author" do
      setup do
        login_as(@author)
        visit briefs_path
      end

      context "displaying brief lists" do
        
        context "drafts" do
          
          setup do
            @draft = Brief.make(:user => @author)
            reload
          end

          should "users drafts should include draft" do
            assert @author.briefs.draft.include?(@draft)
          end
          

          should "have heading" do
            assert_contain("Draft briefs")
          end

          should "have .drafts" do
            assert_select '.draft'
          end

          should "display link for brief title" do
            assert_select 'a[href=?]', edit_brief_path(@draft), :text => @draft.title
          end
          
          context "clicking the link" do
            setup do
              click_link @draft.title
            end
            
            should_respond_with :success
            should_render_template :edit
          end
          
        end
        
        context "published" do
          
          setup do
            @published = Brief.make(:published, :user => @author)
            reload
          end

          should "users drafts should include draft" do
            assert @author.briefs.published.include?(@published)
          end
          

          should "have heading" do
            assert_contain("Published briefs")
          end

          should "have .published" do
            assert_select '.published'
          end

          should "display link for brief title" do
            assert_select 'a[href=?]', brief_path(@published), :text => @published.title
          end
          
          context "clicking the link" do
            setup do
              click_link @published.title
            end
            
            should_respond_with :success
            should_render_template :show
          end
          
        end
        

      end
    end
  
    context "as a standard user" do
      setup do
        login_as(@standard_user)
        visit briefs_path
      end

      context "activity snapshot" do
        should "notify when a brief is due to close submissions"
        should "notify of a brief that requires peer review"
        should "notify when a question has been answered"
        should "display a list of recent activity on all other briefs"
      end
      
      context "watched briefs" do
        setup do
          @brief = Brief.make(:published)
          @standard_user.watch(@brief)
          
          reload    
        end
      
        context "displaying list of watched briefs" do
      
          should "have have some briefs being watched" do
            assert !@standard_user.watching.empty?
          end
      
          should "assign current objects" do
            @standard_user.watching.each do |brief| 
              assert(assigns['current_objects'][:watching].include?(brief), "current_objects should include #{brief.title}") 
            end
          end
      
          should "have heading for watching" do
            assert_select 'h3', :text => 'Watching briefs'
          end
      
          should "have section for watched briefs" do
            assert_select '.watching'
          end
      
          should "have list of briefs" do
            @standard_user.watching.each do |brief|     
              assert_select 'a', :href => brief_path(brief), :text => brief.title
            end
          end
      
        end
      
      end

    end
    
    context "searching" do
      
      should "setup nice searching stuff"
      
    end
    
  end
  
end