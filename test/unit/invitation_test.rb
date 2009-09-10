require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  
  context "should know if it references an existing user" do
    setup do
      @user = User.make
      @invited = User.make
      @brief = Brief.make(:published, { :user => @user })
      
      @invite = @user.invitations.create(
        {:recipient_email => @invited.email, :redeemable => @brief}
      )
    end

    should "respond to existing_user?" do
      assert @invite.existing_user?
    end

  end
    
end
