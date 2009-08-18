class User < ActiveRecord::Base

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end

  has_attached_file :avatar, :styles => { :large => "100x100>", :medium => "48x48>", :small => "32x32>" }
  
  # METHODS FOR BRIEF OWNERSHIP
  
  has_many :briefs, :dependent => :destroy
  
  delegate :draft, :to => :briefs
  delegate :published, :to => :briefs
  
  
  # METHODS FOR WATCHING AND INTERACTING WITH A BRIEF
  
  has_many :questions
  has_many :proposals
  has_many :watched_briefs, :dependent => :destroy
  has_many :brief_user_views, :dependent => :destroy
  
  # pathways to the hallowed briefs
  has_many :responded_briefs, :through => :proposals, :source => :brief
  has_many :watching_briefs, :through => :watched_briefs, :source => :brief
  
  # handle invitations ..
  include Ideapi::HighSociety
  can_grant_invites_to_others :max_invites => 10
  
  has_friends
  
  def friends_not_watching(brief)
    friends - friends_watching(brief)
  end
  
  def friends_watching(brief)
    friends.find(:all, :include => :watched_briefs, :conditions => ["watched_briefs.brief_id = ?", brief.id])
  end
  
  def invite_accepted(invitation)

    (friends << self).each { |friend| 
      
      if !(invitation.redeemed_by.eql?(friend))
        friendship, status = be_friends_with(invitation.redeemed_by)
        
        if status == Friendship::STATUS_REQUESTED
          # the friendship has been requested
          #Mailer.deliver_friendship_request(friendship)
          friendship.accept!      
        elsif status == Friendship::STATUS_ALREADY_FRIENDS
          # they're already friends
        else
          # ...
        end
      
      end
    }
    
    f,s = invitation.redeemed_by.be_friends_with(self)
    f.accept!
  end
  
  # protect against mass assignment
  attr_accessible :login, :email, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at, :last_login_at, :last_request_at, :password, :password_confirmation
  
  def watch(brief)
    return false if !brief
    
    if brief.published?
      watched_briefs.create(:brief => brief)
    else
      errors.add_to_base("You cannot watch a brief which isn't currently published")
      false
    end
  end
  
  def toggle_watch!(brief)
    watching?(brief) ? watching.delete(brief) : watch(brief)
  end
  
  def watching?(brief)
    watching.include?(brief)
  end
  
  def respond_to_brief(brief)
    if brief.published?
      transaction do
        watching.delete(brief)
        proposals.create(:brief => brief)
      end      
    else
      errors.add_to_base("You cannot respond to a brief which isn't currently published")
      false
    end
  end
    
  alias :watching :watching_briefs
  alias :pitching :responded_briefs
  
  delegate :under_review, :to => :responded_briefs
  delegate :complete, :to => :responded_briefs
  
  def author?
    published.empty?
  end
  
  def briefs_grouped_by_state
    returning(BriefCollection.new) do |collection|
      hash = briefs.all.group_by(&:state)
      hash[:watching] = watching if !watching.empty?
      hash[:pitching] = pitching if !pitching.empty?
      
      collection.populate(hash)
    end
  end
  
end
