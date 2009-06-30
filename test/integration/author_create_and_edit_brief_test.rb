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
          assert_equal brief_path(Brief.find_by_title(@brief[:title])), path
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
        click_button "Update"

        assert_response :success
        assert_equal brief_path(@draft), path
        assert_contain(new_message)
        assert_equal(new_message, @draft.reload.most_important_message)
      end
      
      context "brief document" do
        setup do
          assert_equal(edit_brief_path(@draft), path)
        end
        
        should "have brief_items" do
          assert !@draft.brief_items.blank?
        end

        should "display the question / answer blocks that will become the brief document" do
          assert_select("form") do
            @draft.brief_items.each_with_index do |item, index|
              assert_select "#brief_brief_items_attributes_#{index}_id[value=?]", item.id 
              assert_select "#brief_brief_items_attributes_#{index}_title[value=?]", item.title     
              assert_select "textarea#brief_brief_items_attributes_#{index}_body" do |e|
                assert_equal "#{item.body}", e.first.children.first.content
              end
            end
          end
        end
        
        should "be able to update the question / answer blocks" do
          answer = "space and time"
          
          fill_in "brief_brief_items_attributes_0_body", :with => answer
          click_button "Update"
          
          assert_response :success
          assert_equal brief_path(@draft), path
          assert_contain(answer)
          
          assert_equal(answer, @draft.brief_items.reload.first.body)
        end

      end
      
    end

  end
  
end
