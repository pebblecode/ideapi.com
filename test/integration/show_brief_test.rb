require 'test_helper'

class ShowBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper

  context "" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")
      
      @draft = Brief.make(:author => @author)
      @published = Brief.make(:published, :author => @author)
      
      populate_brief(@published)
    end
    
    context "viewing a published brief" do
      
      context "as a brief author" do
        setup do
          login_as(@author)
          visit brief_path(@published)
        end
        
        should_respond_with :success
        should_render_template :show        
      end
      
      context "logged in as standard user" do
        setup do
          @user_session = login_as(@standard_user)
          visit brief_path(@published)
        end

        should "take user back to dashboard" do
          assert_equal(briefs_path, path)
        end
      end
      
      context "as a brief collaborator" do
        setup do
          @user_session = login_as(@standard_user)
          
          @published.users << @standard_user
          visit brief_path(@published)
        end

        should "have the brief title" do
          assert_contain(truncate(@published.title, :length => 30))
        end
        
        should "not have edit link" do
          assert_select 'a[href=?]', edit_brief_path(@published), :count => 0
        end
        
        should "show most important text" do
          assert_contain @published.most_important_message
        end
        
        context "a brief item" do
          setup do
            @item = @published.brief_items.first
          end

          should "display the title" do
            assert_contain(@item.title)
          end
          
          should "display the body" do
            assert_contain(@item.body)
          end
        end
      end
      
      
    end
    
  end
  
end