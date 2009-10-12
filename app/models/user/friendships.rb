class User < ActiveRecord::Base

  has_many_friends

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end

  def friends_not_collaborating(brief)
    friends - brief.users
  end

  def friends_watching(brief)
    friends.find(:all, :include => :watched_briefs, :conditions => ["watched_briefs.brief_id = ?", brief.id])
  end



  def become_friends_and_with_network(contact)
    become_friends_with(contact) unless is_friends_or_pending_with?(contact)
  
    friends.each do |friend|
      unless friend.is_friends_or_pending_with?(contact)
        friend.become_friends_with(contact)
      end
    end
  end

  def make_friends_with(users = [])
    returning ([]) do |friendships|
      users.each { |user|
        friendships << self.request_friendship_with(user)
      }
    end
  end

end