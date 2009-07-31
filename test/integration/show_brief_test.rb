require 'test_helper'

class ShowBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper

  context "" do
    setup do
      @author = User.make(:password => "testing")
      @standard_user = User.make(:password => "testing")
      
      @draft = Brief.make(:user => @author)
      @published = Brief.make(:published, :user => @author)
      
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
        
        
        should "not have form to watch brief" do
          assert_select 'form[action=?][method=?]', watch_brief_path(@published), 'post', :count => 0
        end
        
      end
      
      context "logged in as standard user" do
        setup do
          @user_session = login_as(@standard_user)
          visit brief_path(@published)
        end

        should_respond_with :success
        should_render_template :show
        
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
            
        should "have form to watch brief" do
          assert_select 'form[action=?][method=?]', watch_brief_path(@published), 'post'
        end
        
        should "have watch button" do
          assert_select 'form[action=?][method=?]', watch_brief_path(@published), 'post' do
            assert_select 'input[type=submit][value=?]', 'watch'
          end
        end
        
        context "clicking the watch button" do
          setup do
            click_button 'watch'
          end
        
          should_respond_with :success
        
          should "be watching" do
            assert @standard_user.watching?(@published)
          end
          
          should "not have a watch button" do
            assert_select 'input[type=submit][value=?]', 'watch', :count => 0
          end
        
          should "toggle button to say stop watching" do
            assert_select 'input[type=submit][value=?]', 'stop watching'
          end
        end
        
        context "when watching a brief" do
          setup do
            @standard_user.watch(@published)
            reload
          end
        
          should "show button as stop watching" do
            assert_select 'input[type=submit][value=?]', 'stop watching'
          end
        
          context "clicking the stop watching button" do
            setup do
              click_button 'stop watching'
            end
        
            should "not be watching anymore" do
              assert !@standard_user.watching?(@published)
            end
        
            should "toggle button to say watching" do
              assert_select 'input[type=submit][value=?]', 'watch'
            end
            
            should "not have a stop watching button anymore" do
              assert_select 'input[type=submit][value=?]', 'stop watching', :count => 0
            end
            
          end
        
        end
        # 
        # context "when a brief is updated" do
        #   setup do
        #     @updated_brief_item = @published.brief_items.first
        #   end
        #   
        #   context "brief user views" do
        #     setup do
        #       @updated_brief_item.update_attribute(:body, "ch-ch-changes #{Time.now}")  
        #       @updated_brief_item.reload
        #     end
        #     
        #     should "have value for last_viewed_at" do
        #       assert !@published.brief_user_views.for_user(@standard_user).last_viewed_at.blank?
        #     end
        # 
        #     should "be a difference between user views and brief_item update" do
        #       assert @updated_brief_item.updated_at > @published.reload.brief_user_views.for_user(@standard_user).reload.last_viewed_at
        #     end
        #     
        #     # should "show a flag stating update freshness" do
        #     #   assert_select 'span.updated', :text => '- updated', :count => 1
        #     # end
        #     
        #   end
        #   
        #   context "between login's" do            
        #     context "logging out" do
        #       setup do
        #         logout          
        #       end
        # 
        #       should "be logged out" do
        #         assert(session[:user_credentials].blank?)
        #       end
        #       
        #       context "after updating the brief" do
        #         setup do
        #           @message = "this has been changed"
        #           @updated_brief_item.update_attribute(:body, @message)
        #         end
        #         
        #         should "be changed" do
        #           assert_equal(@message, @updated_brief_item.reload.body)
        #         end
        #         
        #         context "and logging back in" do
        #           setup do
        #             login_as(@standard_user)
        #             visit brief_path(@published)
        #           end
        # 
        #           # should "show update flag" do
        #           #   assert_contain("#{@updated_brief_item.title} - updated")
        #           # end
        #         end
        #         
        #       end
        #       
        #       
        #     end
        #     
        #             
        #   end
        #   
        #   
        # end
        # 
        
      end
      
    end
    
  end
  
end