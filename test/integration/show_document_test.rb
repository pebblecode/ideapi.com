require 'test_helper'

class ShowDocumentTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  include ActionView::Helpers::TextHelper

  context "" do
    setup do
      should_have_template_document
      
      @account, @author = user_with_account
      @standard_user = User.make(:password => "testing")
      
      @draft = Document.make(:author => @author, :account => @account)
      @published = Document.make(:published, :author => @author, :account => @account)
      
      populate_document(@published)
    end
    
    context "viewing a published document" do
      
      context "as a document author" do
        setup do
          login_to_account_as(@account, @author)
          
          visit document_path(@published)
        end
        
        should_respond_with :success
        should_render_template :show
        
        # TODO: should have edit links for all the sections
        
        should "have delete link" do
          assert_select '#document_delete #document_delete_button', :count => 1
        end
      end
      
      context "viewing the document" do
        setup do
          @account.users << @standard_user
          login_to_account_as(@account, @standard_user)
          
          @published.users << @standard_user
          visit document_path(@published)
        end

        should "have the document title" do
          assert_contain(truncate(@published.title, :length => 30))
        end        
        
        context "a document item" do
          setup do
            @item = @published.document_items.first
          end

          should "display the title" do
            assert_contain(@item.title)
          end
          
          should "display the body" do
            assert_contain(@item.body)
          end
        end
        
        context "as a document collaborator" do
          should "not have edit link" do
            assert_select 'a[href=?]', edit_document_path(@published), :count => 0
          end
        end
        
      end
      
    end
    
  end
  
  context "access control: " do
    
    setup do
      should_have_template_document
      
      @account, @user = user_with_account    
      login_to_account_as(@account, @user)
    end

    context "documents user has created" do
      setup do
        @document = Document.make(:published, :author => @user, :account => @account)
        visit document_path(@document)
      end

      should_respond_with :success
    
      should "show the document" do
        assert_equal(document_path(@document), path)
      end
    end
  
    context "documents user is a collaborator" do
      setup do
        @document = Document.make(:published, :account => @account)
        @document.users << @user
        visit document_path(@document)        
      end

      should_respond_with :success
    
      should "show the document" do
        assert_equal(document_path(@document), path)
      end
      
      #context "when user is marked as approver"
      
    end
  
    context "accessing documents when user isn't a collaborator" do
      setup do
        @document = Document.make(:published, :account => @account)
        visit document_path(@document)
        follow_redirect!     
      end
      
      should_respond_with :not_found

    end
  
  end




end