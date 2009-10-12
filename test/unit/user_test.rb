require 'test_helper'

class UserTest < Test::Unit::TestCase
  should_have_attached_file :avatar
  should_have_many :briefs
  should_have_many :questions
  
  should_have_many :proposals
  should_have_many :watched_briefs
  
  # pathways to the hallowed briefs
  should_have_many :responded_briefs
  should_have_many :watching_briefs
  
  should_have_instance_methods :watching, :pitching, :complete, :under_review
  
  context "briefs" do
    setup do
      User.delete_all
      
      @user = User.make
      @draft = Brief.make

      @published = Brief.make(:published)

      assert @draft.draft?
      assert @published.published?
    end

    context "watching" do
      setup do
        assert @user.errors.blank?
        assert @user.watching.blank?
      end

      should "not be able to watch unpublished briefs" do
        assert !@user.watch(@draft)
        assert !@user.errors.blank?
        assert @user.watching.blank?
      end

      should "be able to watch a published brief" do      
        assert @user.watch(@published)
        assert @user.errors.blank?
        assert @user.watching(true).include?(@published)
      end
  
      context "once watching a brief" do
        
        setup do
          @user.watch(@published)
        end
        
        should "be watching the brief" do
          assert @user.watching(true).include?(@published)
        end
        
        should_change "WatchedBrief.count", :by => 1
        
        context "attempting to watch a brief twice" do
          setup do
            @user.watch(@published)
          end
          
          should_not_change "WatchedBrief.count"
          
        end
        
      end

    end

    context "pitching" do
      setup do
        assert @user.errors.blank?
        assert @user.pitching.blank?
      end

      should "not be able to pitch to unpublished briefs" do
        assert !@user.respond_to_brief(@draft)
        assert !@user.errors.blank?
        assert @user.pitching.blank?
      end

      context "pitching on a brief" do
        setup do
          @user.respond_to_brief(@published)
        end
        
        should "be pitching on the brief" do
          assert @user.pitching(true).include?(@published)
        end
        
        should_change "Proposal.count", :by => 1
      end

      should "be able to pitch to a published brief" do      
        assert @user.respond_to_brief(@published)
        assert @user.errors.blank?
        assert @user.pitching(true).include?(@published)
      end

      should "remove brief from watch list when building response" do
        assert @user.watch(@published)
        assert @user.respond_to_brief(@published)
        assert @user.watching.blank?
      end
      
      context "once pitching on a brief" do
        
        setup do
          @user.respond_to_brief(@published)
        end
        
        should "be pitching on the brief" do
          assert @user.pitching(true).include?(@published)
        end
        
        should_change "Proposal.count", :by => 1
        
      end

    end

  end

  context "friendships:" do
    setup do
      @dave = User.make
      @john = User.make
      @henry = User.make
    end

    context "dave and john become friends" do
      setup do
        @dave.become_friends_with(@john)
      end

      context "dave" do
        should "be friends with john" do
          assert @dave.reload.is_friends_with?(@john.reload)
        end
      end
      
      context "john" do
        should "be friends with dave" do
          assert @john.reload.is_friends_with?(@dave.reload)
        end
      end
            
    end
    
  end
  
  context "inviting a user" do
    setup do
      @starting_invite_count = 5
      
      @dave = User.make(:invite_count => @starting_invite_count)
      @brief = Brief.make(:published, {:author => @dave})
      
      @invited = User.plan
      
      @invite = @dave.invitations.make(:recipient_email => @invited[:email], :redeemable => @brief)
    end
  
    should "reduce invite count" do
      assert_equal(@dave.invite_count, (@starting_invite_count - 1))
    end
    
    context "invitee accepts invite" do
      setup do
        @henry = User.make(:email => @invited[:email])
        @invite.redeem_for_user(@henry)
      end

      context "inviter" do
        setup do
          
        end

        should "be friends with invitee" do
          assert @dave.is_friends_with?(@henry)
        end
      end
      
      context "invitee" do
        setup do
          
        end

        should "be friends with inviter" do
          assert @henry.is_friends_with?(@dave)
        end
        
        should "be watching brief" do
          assert @henry.watching?(@brief)
        end
      end
      

    end
    
  
  end
  
  context "inviting existing user when user has no invites to give" do
    setup do
      @dave = User.make(:invite_count => 0)
      @brief = Brief.make(:published, {:author => @dave})
      @invited = User.make
      @invitations = Invitation.from_list_into_hash(
        {:recipient_list => @invited.email, :redeemable => @brief}, @dave
      )
    end

    should_change "Invitation.count", :by => 1
  end
  
  context "beta" do
    setup do
      @user = User.make(:invite_count => nil)
    end

    should "set invite count to 10" do
      assert_equal(10, @user.invite_count)
    end

  end
  

end