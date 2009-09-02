require 'test_helper'

class FriendshipMailerTest < ActionMailer::TestCase  
  tests FriendshipMailer

  context "friendship request" do
    setup do
      @user = User.make
      @friend = User.make
      @friendship, @status = @user.be_friends_with(@friend)
      
      # Send the email, then test that it got queued
      @email = FriendshipMailer.deliver_friendship_request(@friendship)
      
      @host = "http://briefs.ideapi.com"
    end
    
    should "add mail to queue" do
      assert ActionMailer::Base.deliveries.present?
    end
    
    should "address email to friend" do
      assert_equal [@friend.email], @email.to
    end

    should "have relevant title" do
      assert_equal(
        "[IDEAPI] Contact request by one of our members", @email.subject
      )
    end

    should "address friend" do
      assert_match /#{@friend.login}/, @email.body
    end
    
    should "contain friendship link" do
      assert_match(
        /#{@host}\/friendships\/#{@friendship.id}/,
        @email.body
      )
    end
    
    should "contain link to user profile" do
      assert_match(
        /#{@host}\/users\/#{@user.to_param}/,
        @email.body
      )
    end

  end

end
