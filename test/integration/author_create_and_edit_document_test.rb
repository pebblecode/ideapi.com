require 'test_helper'

class AuthorCreateAndEditDocumentTest < ActionController::IntegrationTest
  include DocumentWorkflowHelper
  include DocumentPopulator
  
  context "author" do
    setup do
      should_have_template_document
      
      populate_template_document
      
      @account, @author = user_with_account
      login_to_account_as(@account, @author)
      
      @document = Document.plan(:title => "super_unique_to_this_test_title")
    end
    
    context "creating a document" do
      setup do
        click_link 'create document'
      end

      should_respond_with :success

      should "be able to access new document form" do
        assert_equal new_document_path, path
      end
      
      context "filling in the form" do
        setup do
          fill_in 'document[title]', :with => @document[:title]
          click_button "Create"          
        end
        
        should_respond_with :success
        should_render_template :show
        
        should "update the document count" do
          assert_equal 1, Document.count
        end
      end
      
    end

    context "editing a document" do
      setup do
        @template = populate_template_document
        @draft = Document.make(@document.merge(:author => @author, :template_document => @template, :account => @account))
        visit edit_document_path(@draft)
      end
      
      should "show the edit page" do
        assert_response :success
        assert_equal(edit_document_path(@draft), path)
      end
      
      context "edit form" do
        should "have form" do
          assert_select "form[action=?]", document_path(@draft)
        end
        
        should "have title edit" do
          assert_select "input[type=text][name=?][value=?]", "document[title]", @draft.title
        end
        
        should "have most important message edit" do
          assert_select "textarea#document_most_important_message"
        end
        
        context "updating most important message" do
          setup do
            @new_message = "boom boom my awesome document innit"
            fill_in "document[most_important_message]", :with => @new_message
            click_button "save draft"
            assert_true(redirect?)        
            follow_redirect!            
          end

          should_respond_with :success
          
          should "contain new message" do
            assert_contain(@new_message)
          end
          
        end
        
      end
        
      context "draft document document" do
        setup do
          assert_equal(edit_document_path(@draft), path)
        end
        
        should "have document_items" do
          assert !@draft.document_items.reload.blank?
        end

        should "display the question / answer blocks that will become the document document" do
          assert_select("form") do
            @draft.document_items.each do |item|
              assert_select "input[type=hidden][name=?][value=?]", "document[document_items_attributes][#{item.id}][id]", item.id 
            end
          end
        end
        
        should "gather help text from the question template and display to user" do
          message_count = @draft.document_items.select { |i| !i.help_message.blank?  }.size
          assert_select "p.help_message", :count => message_count
        end
        
        context "updating question / answer block" do
          setup do
            @answer = "space and time"
            @document_item = @draft.document_items.first
          end

          should "fill in answer body" do
            fill_in "document[document_items_attributes][#{@document_item.id}][body]", :with => @answer
          end
          
          should "have save draft button" do
            assert_select 'input[type=submit][value=?]', 'save draft', :count => 1
          end
          
          context "submitting the form" do
            setup do
              fill_in "document[document_items_attributes][#{@document_item.id}][body]", :with => @answer
            end

            context "by clicking save and continue" do
              setup do
                click_button "save draft"
                assert_true(redirect?)        
                follow_redirect!                
              end

              should_respond_with :success                        
              should_render_template :show

              should "should go to show, once saved" do
                assert_equal(document_path(@draft) , path)
              end

              should "contain the answer" do
                assert_contain(@answer)
              end

              should "have updated the object" do
                assert_equal(@answer, @document_item.reload.body)
              end
            end
            
          end
        end
        
        context "publishing" do
          should "have publish button" do
            assert_select 'input[type=submit][value=?]', 'publish', :count => 1 
          end
          
          context "clicking publish button" do
            setup do
              click_button 'publish'
            end

            should "redirect to document" do
              assert_equal document_path(@draft), path
            end
            
            should "publish the document" do
              assert @draft.reload.published?
            end
            
          end
          
        end
        
      end
      
      context "published document" do
        setup do
         @draft.publish!
         @published = @draft.reload         
         # reload page to update changes
         visit edit_document_path(@published)
        end

        should "not have save draft button" do
          assert_not_contain('input[type=submit][value=]')
          assert_select 'input[type=submit][value=?]', 'Save draft', :count => 0
        end
        
        should "have update button in place of update button" do
          assert_select 'input[type=submit][value=?]', 'publish', :count => 0
          assert_select 'input[type=submit][value=?]', 'update'
        end

        should "update record" do
          new_message = "changing the published document"

          fill_in "document[most_important_message]", :with => new_message
          click_button "Update"
          
          assert_response :success
          assert_equal document_path(@published), path
          assert_contain(new_message)
          assert_equal(new_message, @published.reload.most_important_message)
        end
        
        should "have not have a delete link" do
          assert_select "a[href=?]", delete_document_path(@published), :count => 0
        end
        
      end
      
      
    end

  end
  
end
