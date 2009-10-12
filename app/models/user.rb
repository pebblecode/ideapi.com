require 'friendship'

class User < ActiveRecord::Base
  
  concerned_with :validations, 
    :relationships, 
    :states, 
    :invitations, 
    :briefs, 
    :class_methods,
    :friendships
    
  # users are found by username
  def to_param
    return self.login
  end
  
  # called from proposal_observer
  def proposal_created(proposal)
    stop_watching_brief(proposal)
  end
  
  def extract_existing_users(list)
    User.extract_existing_users_from(self, list)
  end
  
  def extract_existing_users_and_friendships(list)
    User.extract_existing_users_and_friendships(self, list)
  end
  
  private
  
  def stop_watching_brief(proposal)
    toggle_watch!(proposal.brief) if watching?(proposal.brief)
  end

end
