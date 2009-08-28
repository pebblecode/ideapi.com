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
        
        @invite_count_before_invite = @user.invite_count
      end

      should "show number of invites" do
        assert_contain(@invite_count_before_invite.to_s)
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
            @user.be_friends_with!(friend); 
            friend.reload
          }
          
          @user.reload
          reload
        end
        
        should "have friendships" do
          @friends.each { |f| assert @user.friends?(f) }
        end
        
        should "have form for inviting people" do
          assert_select 'form[action=?][method=post]', invitations_path
        end
        
        should "have a drop down of friends to invite" do
          assert_select 'select[name=?]', "invitation[recipient_list]" do
            @friends.each do |friend|
              assert_select 'option[value=?]', friend.email, :text => friend.login
            end
          end
        end
        
        context "clicking invite" do
          setup do
            @invited_friend = @friends.first
            select @invited_friend.login, :from => 'invitation[recipient_list]'
            click_button 'invite'
          end
          
          should_respond_with :success
          
          should "take user back to brief" do
            assert_equal(brief_path(@brief), path)
          end
        
          context "when invited user accepts" do
            setup do
              @invitation = @user.invitations.find_by_recipient_email(@invited_friend.email)
              @invitation.redeem_for_user(@invited_friend)
              reload
            end
            
            should "have invited username" do
              assert_select '.watching' do
                assert_select 'a[href=?]', user_path(@invited_friend) , :text => @invited_friend.login
              end
            end
            
            should "not have invited friend in the invite dropdown" do
              assert_select 'select[name=?]', "invitation[recipient_list]" do
                assert_select 'option[value=?]', @invited_friend.email, :text => @invited_friend.login, :count => 0
              end
            end
          
          end
          
        end
        
         context "with friends already watching brief" do
          
          setup do
            @friends.first.watch(@brief)
            reload
          end
        
          context "friend" do
            should "be watching brief" do
              assert @friends.first.watching?(@brief)
            end
          end
        
          should "have a drop down of friends to invite" do
            assert_select 'select[name=?]', "invitation[recipient_list]" do
              watching_dude, *others = @friends
              assert_select 'option[value=?]', watching_dude.email, :text => watching_dude.login, :count => 0
              others.each do |friend|
                assert_select 'option[value=?]', friend.email, :text => friend.login
              end
            end
          end
          
        end
        
        context "inviting friends via the email list" do
          setup do
            @invite_count = @user.invite_count
            
            fill_in 'invitation_recipient_list', :with => @friends.first.email
            click_button 'invitation_submit'
          end

          should_respond_with :success
          should_change "Invitation.count", :by => 1
          
          should "not change the invite count" do
            assert_equal(@invite_count, @user.reload.invite_count)
          end
          
          context "invite" do
            setup do
              @invite = @user.invitations.find_by_recipient_email(
                @friends.first.email
              )
            end

            should "be redeemable for brief" do
              assert_equal(@brief, @invite.redeemable)
            end
          end
          
        end
        
      end  
      
      context "inviting yourself" do
        
        setup do
          fill_in 'invitation_recipient_list', :with => @user.email
          click_button 'Invite'
        end
        
        should_respond_with :success
        should_change "Invitation.count", :by => 0
      
      end      
            
    end
  end 
  
   context "" do
    
    setup do
      @invited_by = User.make
      # give inviter some friends too
      
      @friends = 3.times.map { User.make }
      
      @friends.each { |friend| 
        @invited_by.be_friends_with!(friend); 
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
          assert @invited_by.friends?(@invite.reload.redeemed_by)
        end
        
        should "invitor should be friends with user" do
          assert @invite.reload.redeemed_by.friends?(@invited_by.reload)
        end
        
        should "users friends should be friends with invited" do
          @friends.each { |friend| 
            friend.friends?(@invite.reload.redeemed_by) }          
        end
        
        should "invited should be friends with inviters friends" do
          @friends.each { |friend| 
            @invite.reload.redeemed_by.friends?(friend) }
        end
        
      end
    end
    
  end 
  
end
