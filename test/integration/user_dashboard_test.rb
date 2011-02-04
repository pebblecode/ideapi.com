require 'test_helper'

class UserDocumentsTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  
  context "" do
    setup do
      should_have_template_document
      
      @account, @user = user_with_account    
    end
    
    context "as any type of user" do
      setup do
        login_to_account_as(@account, @user)
        visit documents_path
      end

      should_assign_to :current_objects
      should_respond_with :success
      should_render_template :index
    
      context "first visit" do
        setup do
          visit documents_path
        end

        should "get documents" do
          assert_equal documents_path, path
        end
        
        should "have link to create a document" do
          assert_select 'a[href=?]', new_document_path, :text => 'Create document'
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