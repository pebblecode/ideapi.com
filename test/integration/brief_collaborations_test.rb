require 'test_helper'

class BriefCollaborationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "" do
    setup do
      should_have_template_brief

      @account, @author = user_with_account
      @standard_user = User.make(:password => "testing")

      @draft = Brief.make(:author => @author, :account => @account)
      @published = Brief.make(:published, :author => @author, :account => @account)

      populate_brief(@published)
    end

    context "viewing a published brief" do

      context "as a brief author" do
        setup do
          login_to_account_as(@account, @author)
          visit brief_path(@published)
        end
        
        context "selecting user from dropdown" do
          setup do
            
          end
          
          should "be add users to brief" do

          end
        end
        

        
        context "with users on brief" do
          setup do      
            @published.users << returning([]) do |users|
              3.times do
                users << User.make
              end
            end
            reload
          end

          should "contain list of collaborators" do
            assert_select '.collaborators a[href=?]', user_path(@published.users.last), 
              :text => @published.users.last.full_name.titlecase
          end
          
          should "be able to mark user as author"
          should "be able to mark user as approver"
          should "be able to remove user"
        
        end
        
      end
    
      context "as any user" do
        should "see a list of collaborators"
        should "see users marked as authors"
        should "see users marked as collaborators"
      end
    
    end

      # removing a user should not break comments etc ..
      # 
      # deleting a user should not break comments ..
      
            
      # context "removing last author" do
      #   setup do
      #     check 'brief_user_briefs_attributes_0__delete'
      #     click_button 'Save Changes'
      #   end
      # 
      #   should_not_change("Collaborator count") { UserBrief.count }
      # end
      
      # should "be author" do
      #   assert @published.authors.include?(@author)
      # end
      # 
      # context "revoking write access to the only author" do
      #   
      #   setup do
      #     uncheck 'brief_user_briefs_attributes_0_author'
      #     click_button 'update'
      #   end
      # 
      #   should "still be author" do
      #     assert @published.authors.reload.include?(@author)
      #   end
      #   
      #   should "have errors" do
      #     assert(@published.errors.on(:user_briefs).present?)
      #   end
      # end
      # 
    
  end

end