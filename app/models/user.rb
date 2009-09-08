require 'friendship'

class User < ActiveRecord::Base

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email 
  end

  has_attached_file :avatar, :styles => { 
    :large => "100x100>", :medium => "48x48>", :small => "32x32>" 
  }
  
  validates_uniqueness_of :login, :email, :message => "already taken"
  validates_format_of :login, 
    :with => /^[\w\d]+$/, 
    :message => "must be a single combination of letters (numbers and underscores also allowed)"
  
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validates_presence_of :first_name, 
    :on => :create, 
    :message => "needed if you give your last name", 
    :if => Proc.new { |u| u.last_name.present? }
  
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
  
  # users are found by username
  def to_param
    return self.login
  end
  
  # handle invitations ..
  include Ideapi::HighSociety
  can_grant_invites_to_others :max_invites => 10, :initialise_with => 10
  
  has_many_friends
  
  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
  
  def friends_not_watching(brief)
    friends - brief.watchers
  end
  
  def friends_watching(brief)
    friends.find(:all, :include => :watched_briefs, :conditions => ["watched_briefs.brief_id = ?", brief.id])
  end
  
  def invite_accepted(invitation)
    if invitation.respond_to?(:redeemed_by) && invitation.redeemed_by.present?
      unless is_friends_or_pending_with?(invitation.redeemed_by)
        become_friends_with(invitation.redeemed_by) 
      end
    end
  end
  
  def invite_redeemed(invitation)
    if invitation.redeemable.present? && invitation.redeemable.is_a?(Brief)  
      watch(invitation.redeemable)
    end
  end
  
  def become_friends_and_with_network(contact)
    become_friends_with(contact) unless is_friends_or_pending_with?(contact)
    
    friends.each do |friend|
      unless friend.is_friends_or_pending_with?(contact)
        friend.become_friends_with(contact)
      end
    end
  end
    
  # protect against mass assignment
  attr_accessible :login, :email, :avatar_file_name, :avatar_content_type, :avatar_file_size, :avatar_updated_at, :last_login_at, :last_request_at, :password, :password_confirmation, :avatar, :first_name, :last_name
  
  def watch(brief)
    return false if !brief
    
    if brief.published?
      watched_briefs.create(:brief => brief) unless self.owns?(brief)
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
        proposals.create(:brief => brief, :title => "Your response to #{brief.title}", :long_description => "Enter your response here")
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
  
  def owns?(thing)
    assoc = thing.class.to_s.tableize
    respond_to?(assoc) && send(assoc).include?(thing)
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
