require 'test_helper'

class InvitationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "logged in" do
    setup do
      @user = User.make(:password => "testing", :invite_count => 10)
      login_as(@user)
    end
        
    context "profile page" do
      setup do
        visit user_path(@user)
        
        @invite_count_before_invite = @user.invite_count
      end

      should "show number of invites" do
        assert_contain(@invite_count_before_invite.to_s)
      end
      
      context "sending invites" do
        
      end
      
      
      context "with invites sent" do
        setup do
          @email = Faker::Internet.email
          fill_in 'invitation[recipient_list]', :with => @email
          click_button 'Invite'
        end
        
        should_respond_with :success
        should_change "Invitation.count", :by => 1
        
        should "show decremented invite count" do
          assert_contain((@invite_count_before_invite - 1).to_s)
        end
        
        should_set_the_flash_to :notice=>"An invite has been sent to #{@email}"
          
        context "showing the invite" do
          setup do
            @invite = @user.invitations.find_by_recipient_email(@email)
          end

          should "show the invite" do
            assert_contain(@invite.recipient_email)
          end
          
          should "show status" do
            assert_contain(@invite.state.to_s)
          end

          should "have resend link" do
            assert_select 'a[href=?]', resend_invitation_path(@invite.code), :text => '(resend invite)'
          end

          should "have a cancel link" do
            assert_select 'a[href=?]', cancel_invitation_path(@invite.code), :text => 'cancel'
          end

          context "cancelling an invite" do
            setup do
              click_link 'cancel'
            end

            should "should cancel the invitation" do
              assert @invite.reload.cancelled?
            end

            should "grant user an invite back" do
              assert_equal @user.reload.invite_count, (@invite_count_before_invite) 
            end
          end

        end
        
      end
      
    end
      
    context "viewing a brief" do
      setup do
        @brief = Brief.make(:published, { :author => @user })
        visit brief_path(@brief)
      end

      context "with friends, updating collaborators" do
        setup do
          @friends = 3.times.map { User.make }
          
          @friends.each { |friend| 
            @user.become_friends_with(friend); 
            friend.reload
          }
          
          @user.reload
          
          visit collaborators_brief_path(@brief)
        end
        
        should "have a drop down of friends to add to brief" do          
          assert_select 'select#brief_user_briefs_attributes_1_user_id' do
            @friends.each do |friend|
              assert_select 'option[value=?]', friend.id, :text => friend.login
            end
          end
        end
        
        context "adding them to the brief" do
          setup do
            @invited_friend = @friends.first
            select @invited_friend.login, :from => 'brief_user_briefs_attributes_1_user_id'
            click_button 'Add to brief'
          end
          
          should_not_change "Invitation.count"
          
          should_respond_with :success
          
          should "take user back to brief" do
            assert_equal(brief_path(@brief), path)
          end
        
          should "automatically add user to collaborators list" do
            assert_select '.collaborators' do
              assert_select 'a[href=?]', user_path(@invited_friend)
            end
          end
          
          context "after adding user, editing collaborators" do
            setup do
              visit collaborators_brief_path(@brief)
            end

            should "not have invited friend in the add collaboration dropdown" do
              assert_select "select#brief_user_briefs_attributes_2_user_id" do
                assert_select 'option[value=?]', @invited_friend.id, :text => @invited_friend.login, :count => 0
              end
            end
          end
          
        end

      end  
    end
  end 
  
   context "" do
    
    setup do
      @invited_by = User.make
      # give inviter some friends too
      
      @friends = 3.times.map { User.make }
      
      @friends.each { |friend| 
        @invited_by.become_friends_with(friend); 
        friend.reload
      }
      
      @invite = Invitation.make(:user => @invited_by)
    end
    
    context "visiting valid invite link" do
      setup do
        visit invitation_path(@invite.code)
      end
    
      should_respond_with :success
      
      should "take user to sign up page" do
        assert_equal(new_user_path(:invite => @invite.code), path)
      end
      
      context "signing up" do
        setup do
          @user = User.plan
          fill_in 'user_login', :with => @user[:login]
          fill_in 'First name', :with => @user[:first_name]
          fill_in 'Last name', :with => @user[:last_name]
          fill_in 'Email', :with => @user[:email]
          fill_in 'Password', :with => "testing"
          fill_in 'Password confirmation', :with => "testing"
          click_button 'Sign up'
        end
        
        should_respond_with :success
        should_change "User.count", :by => 1

      end
      
    
    end
    
    context "invalid invite" do
      
      context "visiting invitation path" do
        setup do
          visit invitation_path("imabadasshacker")
        end
    
        should "take user away from signup" do
          assert_equal('/', path)
        end
      end
      
      context "visiting signup path" do
        setup do
          visit new_user_path(:invite => "imabadasshacker")
        end
    
        should "take user away from signup" do
          assert_equal('/', path)
        end
      end
    
    end
    
    context "signup from an invite" do
      setup do
        visit new_user_path(:invite => @invite.code)
      end
  
      should_respond_with :success
      should_render_template :new
  
      context "submitting signup form" do
        setup do
          password = "testing"
          
          @user = User.plan(:password => password)
          
          fill_in 'screen name', :with => @user[:login]
          fill_in 'email', :with => @user[:email]
          
          fill_in 'password', :with => password
          fill_in 'user_password_confirmation', :with => password
          
          click_button 'sign up'
        end
        
        should_respond_with :success
        
        should_change "User.count", :by => 1
        
        should "redeem the invite" do
          assert @invite.reload.accepted?
        end
        
        should "redeem the invite to the new user" do
          user = User.find_by_login(@user[:login])
          assert_equal(user, @invite.reload.redeemed_by) 
        end
        
        should "redirect to sign in" do
          assert_equal(briefs_path, path)
        end
        
        should "become friends with user who invited them" do
          assert @invited_by.reload.is_friends_with?(@invite.reload.redeemed_by)
        end
        
        should "invitor should be friends with user" do
          assert @invite.reload.redeemed_by.is_friends_with?(@invited_by.reload)
        end
        
        should "users friends should be friends with invited" do
          @friends.each { |friend| 
            friend.is_friends_with?(@invite.reload.redeemed_by) }          
        end
        
        should "invited should be friends with inviters friends" do
          @friends.each { |friend| 
            @invite.reload.redeemed_by.is_friends_with?(friend) }
        end
        
      end
    end
    
  end 
  
end
