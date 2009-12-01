require 'test_helper'

class AuthorCreateAndEditBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include BriefPopulator
  
  context "author" do
    setup do
      should_have_template_brief
      
      populate_template_brief
      
      @account, @author = user_with_account
      login_to_account_as(@account, @author)
      
      @brief = Brief.plan(:title => "super_unique_to_this_test_title")
    end
    
    context "creating a brief" do
      setup do
        # assert_equal dashboard_path, path
        click_link 'create brief'
      end

      should_respond_with :success

      should "be able to access new brief form" do
        assert_equal new_brief_path, path
      end
      
      context "filling in the form" do
        setup do
          fill_in 'brief[title]', :with => @brief[:title]
          fill_in 'brief[most_important_message]', :with => @brief[:most_important_message]
          click_button "Create"
        end
        
        should_respond_with :success
        should_render_template :edit
        
        should_change "Brief.count", :by => 1
      end
      
    end

    context "editing a brief" do
      setup do
        @template = populate_template_brief
        @draft = Brief.make(@brief.merge(:author => @author, :template_brief => @template, :account => @account))
        visit edit_brief_path(@draft)
      end
      
      should "show the edit page" do
        assert_response :success
        assert_equal(edit_brief_path(@draft), path)
      end
      
      context "edit form" do
        should "have form" do
          assert_select "form[action=?]", brief_path(@draft)
        end
        
        should "have title edit" do
          assert_select "input[type=text][name=?][value=?]", "brief[title]", @draft.title
        end
        
        should "have most important message edit" do
          assert_select "textarea#brief_most_important_message"
        end
        
        context "updating most important message" do
          setup do
            @new_message = "boom boom my awesome brief innit"
            fill_in "brief[most_important_message]", :with => @new_message
            click_button "save draft"
          end

          should_respond_with :success
          
          should "contain new message" do
            assert_contain(@new_message)
          end
          
        end
        
      end
        
      context "draft brief document" do
        setup do
          assert_equal(edit_brief_path(@draft), path)
        end
        
        should "have brief_items" do
          assert !@draft.brief_items.reload.blank?
        end

        should "display the question / answer blocks that will become the brief document" do
          assert_select("form") do
            @draft.brief_items.each do |item|
              assert_select "input[type=hidden][name=?][value=?]", "brief[brief_items_attributes][#{item.id}][id]", item.id 
            end
          end
        end
        
        should "gather help text from the question template and display to user" do
          message_count = @draft.brief_items.select { |i| !i.help_message.blank?  }.size
          assert_select "p.help_message", :count => message_count
        end
        
        context "updating question / answer block" do
          setup do
            @answer = "space and time"
            @brief_item = @draft.brief_items.first
          end

          should "fill in answer body" do
            fill_in "brief[brief_items_attributes][#{@brief_item.id}][body]", :with => @answer
          end
          
          should "have save draft button" do
            assert_select 'input[type=submit][value=?]', 'save draft', :count => 1
          end
          
          context "submitting the form" do
            setup do
              fill_in "brief[brief_items_attributes][#{@brief_item.id}][body]", :with => @answer
            end

            context "by clicking save and continue" do
              setup do
                click_button "save draft"
              end

              should_respond_with :success                        
              should_render_template :edit

              should "should come back to edit once saved" do
                assert_equal(edit_brief_path(@draft) , path)
              end

              should "contain the answer" do
                assert_contain(@answer)
              end

              should "have updated the object" do
                assert_equal(@answer, @brief_item.reload.body)
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

            should "redirect to brief" do
              assert_equal brief_path(@draft), path
            end
            
            should "publish the brief" do
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
         visit edit_brief_path(@published)
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

          fill_in "brief[most_important_message]", :with => new_message
          click_button "Update"
          
          assert_response :success
          assert_equal brief_path(@published), path
          assert_contain(new_message)
          assert_equal(new_message, @published.reload.most_important_message)
        end
        
        should "have not have a delete link" do
          assert_select "a[href=?]", delete_brief_path(@published), :count => 0
        end
        
      end
      
      
    end

  end
  
end
