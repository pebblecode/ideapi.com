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
        
        
        should "have edit link" do
          assert_select 'a[href=?]', edit_brief_path(@published), :count => 1
        end
        
        should "have delete link" do
          assert_contain('delete brief')
        end
      end
      
      context "viewing the brief" do
        setup do
          @user_session = login_as(@standard_user)
          @published.users << @standard_user
          visit brief_path(@published)
        end

        should "have the brief title" do
          assert_contain(truncate(@published.title, :length => 30))
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
        
        context "as a brief collaborator" do
          should "not have edit link" do
            assert_select 'a[href=?]', edit_brief_path(@published), :count => 0
          end
        end
        
      end
      
    end
    
  end
  
  context "access control: " do
    
    setup do
      @user = User.make(:password => "testing")
      login_as(@user)
    end

    context "briefs user has created" do
      setup do
        @brief = Brief.make(:published, :author => @user)
        visit brief_path(@brief)
      end

      should_respond_with :success
    
      should "show the brief" do
        assert_equal(brief_path(@brief), path)
      end
    end
  
    context "briefs user is a collaborator" do
      setup do
        @brief = Brief.make(:published)
        @brief.users << @user
        visit brief_path(@brief)        
      end

      should_respond_with :success
    
      should "show the brief" do
        assert_equal(brief_path(@brief), path)
      end
      
      context "when user is marked as approver" do
        setup do
          # @brief = Brief.make
          # visit brief_path(@brief)
        end

      end
      
    end
  
    context "accessing briefs when user isn't a collaborator" do
      setup do
        @brief = Brief.make(:published)
        visit brief_path(@brief)        
      end
      
      should_respond_with :not_found

    end
  
  end




end