class FriendshipMailer < ActionMailer::Base
  
  def friendship_request(friendship, sent_at = Time.now)
    @subject = "[IDEAPI] Contact request by one of our members" 
    @body[:friendship] = friendship
    @recipients = friendship.friend.email
    @from = 'support@ideapi.com'
    @sent_on = sent_at
  end

end
