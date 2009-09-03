class FriendshipObserver < ActiveRecord::Observer

  def after_create(friendship)
    if friendship.pending?
      FriendshipMailer.deliver_friendship_request(friendship)
    end    
  end

end
