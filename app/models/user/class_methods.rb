class User < ActiveRecord::Base

  class << self
  
    def extract_existing_users(user, list)
      existing, to_invite = [], []

      emails_from_string(list).each do |email|
        if user = User.find_by_email(email)
          existing << user          
        else
          to_invite << email
        end
      end

      return existing, to_invite
    end
    
    def extract_existing_users_and_friendships(user, list)      
      existing, to_invite = extract_existing_users(user, list)
      friends = []
      
      existing.delete_if do |existing_user|
        already_friends = user.is_friends_with?(existing_user)
        friends << existing_user if already_friends
        already_friends
      end
      
      return friends, existing, to_invite
    end
    
    def emails_from_string(str)
      str.split(/,|\s/).reject {|email| email.blank? || !valid_email?(email) }
    end  
    
    def email_regex
      @email_regex ||= /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    end
          
    def valid_email?(email)
      (email =~ email_regex ? true : false)
    end
  
  end

end