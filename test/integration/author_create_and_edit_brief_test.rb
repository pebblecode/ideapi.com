require 'test_helper'

class AuthorCreateAndEditBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include BriefPopulator
  
  context "author" do
    setup do
      populate_template_brief
      
      @author = Author.make(:password => "testing")
      login_as(@author)
      
      @brief = Brief.plan(:title => "super_unique_to_this_test_title")
    end
    
    context "creating a brief" do
      setup do
        assert_equal briefs_path, path
        click_link 'create brief'
      end

      should "be able to access new brief form" do
        assert_response :success
        assert_equal new_brief_path, path
      end

      should "create form layout" do
        assert_difference "Brief.count", 1 do
          assert_select("form")          
          fill_in 'brief[title]', :with => @brief[:title]
          fill_in 'brief[most_important_message]', :with => @brief[:most_important_message]
          click_button "Create"
          assert_response :success
          assert_equal edit_brief_path(Brief.find_by_title(@brief[:title])), path
        end
      end
    end

    context "editing a brief" do
      setup do
        @template = populate_template_brief
        @draft = Brief.make(@brief.merge(:author => @author, :template_brief => @template))
        visit edit_brief_path(@draft)
      end
      
      should "show the edit page" do
        assert_response :success
        assert_equal(edit_brief_path(@draft), path)
      end
      
      should "have form for editing" do
        assert_select "form[action=?]", brief_path(@draft) do
          assert_select "input[type=hidden][name=_method][value=?]", "put"
          assert_select "input[type=text][name=?][value=?]", "brief[title]", @draft.title
          
          assert_select "textarea#brief_most_important_message" do |e|
            # bit weird this, and maybe the is an eaiser way,
            # but it essentially just picks out the content on the
            # text area .. raise e.first.to_yaml to see all the shizzle
            assert_equal @draft.most_important_message, e.first.children.first.content
          end
        end
      
        new_message = "boom boom my awesome brief innit"
      
        fill_in "brief[most_important_message]", :with => new_message
        click_button "save and continue editing"

        assert_response :success
        assert_equal edit_brief_path(@draft), path
        assert_contain(new_message)
        assert_equal(new_message, @draft.reload.most_important_message)
      end
      
      context "draft brief document" do
        setup do
          assert_equal(edit_brief_path(@draft), path)
        end
        
        should "have brief_items" do
          assert !@draft.brief_items.blank?
        end

        should "display the question / answer blocks that will become the brief document" do
          assert_select("form") do
            @draft.brief_items.each do |item|
              assert_select "input[type=hidden][name=?][value=?]", "brief[brief_items_attributes][#{item.id}][id]", item.id 
              #assert_select "#brief_brief_items_attributes_#{index}_title[value=?]", item.title     
              # assert_select "textarea[name=?]", "brief[brief_items_attributes][#{item.id}][body]" do |e|
              #   assert_equal "#{item.body}", e.first.children.first.content
              # end
            end
          end
        end
        
        should "give optional class to questions that are optional" do
          optional_count = @draft.brief_items.select(&:optional).size
          assert_select "li.brief_item.optional_brief_item", :count => optional_count
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
            assert_select 'input[type=submit][value=?]', 'Save and continue editing', :count => 1
          end
          
          context "submitting the form" do
            setup do
              fill_in "brief[brief_items_attributes][#{@brief_item.id}][body]", :with => @answer
            end

            context "by clicking save and continue" do
              setup do
                click_button "save and continue editing"
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
        
        should "have publish button" do
          assert_select 'input[type=submit][value=?]', 'Publish', :count => 1    
          
          click_button 'publish'
          assert_equal brief_path(@draft), path
          assert @draft.reload.published?
        end
      end
      
      context "published document" do
        setup do
         @draft.publish!
         @published = @draft.reload
         assert @published.published?
         
         # reload page to update changes
         reload
        end

        should "not have save draft button" do
          assert_not_contain('input[type=submit][value=]')
          assert_select 'input[type=submit][value=?]', 'Save draft', :count => 0
        end
        
        should "have update button in place of update button" do
          assert_select 'input[type=submit][value=?]', 'Publish', :count => 0
          assert_select 'input[type=submit][value=?]', 'Update and continue editing', :count => 1
        end
        
        should "disable changing some of the brief_item attributes once published" do
          assert_select("form") do
            @draft.brief_items.each do |item|              
              assert_select "#brief_brief_items_attributes_#{item.id}_id[value=?]", item.id 
              
              # titles should not be editable
              assert_select "input[value=?]", item.title, :count => 0
              assert_select 'p', :text => item.title
              
              assert_select "textarea[name=?]", "brief[brief_items_attributes][#{item.id}][body]" do |e|
                assert_equal "#{item.body}", e.first.children.first.content
              end
            end
          end
        end
        
        should "update record" do
          new_message = "changing the published document"

          fill_in "brief[most_important_message]", :with => new_message
          click_button "Update"
          
          assert_response :success
          assert_equal edit_brief_path(@published), path
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
