require 'test_helper'

class InvitationsTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "logged in" do
    setup do
      @user = User.make(:password => "testing", :invite_count => 10)
      login_as(@user)
    end
    
    context "the dashboard" do
      setup do
        visit briefs_path
      end
  
      should "contain an invitation form" do
        assert_select 'form[action=?]', invitations_path 
      end
    
      
      context "filling in invitations" do
        
        setup do
          @valid_emails = 3.times.map { Faker::Internet::email }
        end
        
        context "with valid email addresses" do
          setup do
            fill_in 'invitation_recipient_list', :with => @valid_emails.join(", ")
            click_button 'Invite'
          end
  
          should_respond_with :success          
          should_change "Invitation.count", :by => 3
          
        end
        
        context "with invalid email addresses" do
          setup do
            fill_in 'invitation_recipient_list', :with => "bads.food.com, dsadsa@dasda"
            click_button 'Invite'
          end
          
          should_respond_with :success
          should_change "Invitation.count", :by => 0
    
        end
        
        context "with mix of valid/invalid email addresses" do
          setup do
            fill_in 'invitation_recipient_list', :with => "bads.food.com, dsadsa@dasda, #{@valid_emails.join(", ")}"
            click_button 'Invite'
          end
          
          should_respond_with :success
          should_change "Invitation.count", :by => 3
    
        end

      end
            
    end
    
    
    context "profile page" do
      setup do
        visit user_path(@user)
      end

      should "show number of invites" do
        assert_contain("#{@user.invite_count}")
      end
      
      
      context "with invites sent" do
        setup do
          @invite_count_before_invite = @user.invite_count
          @invite = @user.invitations.make
          reload
        end
        
        should "reduce invite count" do
          assert_equal(@invite_count_before_invite - 1, @user.reload.invite_count)
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
      
  
    context "viewing a brief" do
      setup do
        @brief = Brief.make(:published, { :user => @user })
        visit brief_path(@brief)
      end
  
      context "with no friends" do
        should "contain an invitation form" do
          assert_select 'form[action=?]', invitations_path 
        end
      end
      
      context "with friends" do
        setup do
          @friends = 3.times.map { User.make }
          
          @friends.each { |friend| 
            friendship, status = @user.be_friends_with(friend); 
            friendship.accept!
            friend.reload
          }
          
          @user.reload
          reload
        end
        
        should "have friendships" do
          @friends.each { |f| assert @user.friends?(f) }
        end
        
        should "have form for inviting people" do
          assert_select 'form[action=?][method=post]', invite_brief_path(@brief)
        end
        
        should "have a drop down of friends to invite" do
          assert_select 'select[name=?]', "invitation[user]" do
            @friends.each do |friend|
              assert_select 'option[value=?]', friend.id, :text => friend.login
            end
          end
        end
        
        context "clicking invite" do
          setup do
            @invited_friend = @friends.first
            select @invited_friend.login, :from => 'invitation[user]'
            click_button 'invite'
          end
          
          should_respond_with :success
          
          should "not have invited friend in the invite dropdown" do
            assert_select 'select[name=?]', "invitation[user]" do
              assert_select 'option[value=?]', @invited_friend.id, :text => @invited_friend.login, :count => 0
            end
          end
          
          should "take user back to brief" do
            assert_equal(brief_path(@brief), path)
          end
          
          should "have people on brief section" do
            assert_contain("People on this brief")
          end
          
          should "have invited username" do
            assert_select '.watching' do
              assert_select 'a[href=?]', user_path(@invited_friend) , :text => @invited_friend.login
            end
          end
      
        end
        
        
      end
            
    end
  end 
  
  context "" do
    
    setup do
      @invited_by = User.make
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
          
          fill_in 'login', :with => @user[:login]
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
          assert @invited_by.friends?(@invite.reload.redeemed_by)
        end
        
      end
    end
    
  end 
  
end
