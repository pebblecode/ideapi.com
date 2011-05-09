require 'test_helper'

class CompletedDocumentsTest < ActionController::IntegrationTest

  include DocumentWorkflowHelper
  
  context "" do
    setup do
      should_have_template_document
      
      @account, @user = user_with_account    
      
      @document = Document.make(:author => @user, :account => @account)
      
      login_to_account_as(@account, @user)
      
      visit edit_document_path(@document)
    end
    
    context "draft document" do
      # https://abutcher.lighthouseapp.com/projects/32755/tickets/41-bug-reactive-button-visible
      
      should "not have link to reactivate" do
        assert_select 'input[type=submit][value=?]', 'reactivate', :count => 0
      end
      
    end
    
    
    context "published document" do
      
      setup do
        click_button 'publish'
      end
      
      should "be active" do
        assert @document.reload.published?
      end
      
      context "setting a document as completed" do
        
        setup do
          visit document_path(@document)
        end
        
        should "have button to archive" do
          assert_select 'input[type=submit][value=?]', 'archive', :count => 1
        end
        
        context "clicking mark as complete" do
          setup do
            click_button 'archive'   
            follow_redirect!
          end
      
          should_respond_with :success
      
          should "now be complete" do
            assert @document.reload.complete?
          end
        end
      
      end
      
    end
  
  end

end
