require 'test_helper'

class UserDashboardTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "" do
    setup do
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

    context "briefs user has created" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
    context "briefs user is marked as approver" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
    context "briefs user is a collaborator" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
    context "accessing briefs when user isn't a collaborator" do
      setup do
        
      end

      should "description" do
        
      end
    end
    
    
  
  end
  
end