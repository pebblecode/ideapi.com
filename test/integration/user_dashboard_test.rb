require 'test_helper'

class UserDashboardTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "" do
    setup do
      @user = User.make(:password => "testing")
    end
    
    context "as any type of user" do
      setup do
        login_as(@user)
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
        
        should "have link to create a brief" do
          assert_select 'a[href=?]', new_brief_path, :text => 'Create brief'
        end
      end
      
      context "session data" do
        setup do
          @user.reload
        end

        should "set last_request_at when logging in" do
          assert(!@user.last_request_at.blank?)
        end
        
        should "have recent last_request_at after logging in" do
          assert((Time.now - @user.last_request_at) < 1.minute)
        end
      end
             
    end
     
  end
  
end