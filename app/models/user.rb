#require 'friendship'
require 'digest/md5'

class User < ActiveRecord::Base
  validates_acceptance_of :terms_of_service, :message => "Must accept the Terms and Conditions", :accept => "1"
  attr_accessible :terms_of_service
  
  concerned_with :briefs,
    :class_methods,
    :relationships,  
    :validations
    
  # users are found by username
  def to_param
    self.screename || self.id.to_s
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
  
  include Ideapi::Schizo
  
  state :pending, :default => true do
    handle :activate! do
      self.invite_code = nil
      stored_transition_to(:active)
    end
  
    handle :cancel! do
      stored_transition_to(:cancelled)
    end    
  end
  
  state :active
  state :cancelled
  
  become_schizophrenic
  
  before_save :ensure_default_state
  
  def full_name
    name_parts(:first_name, :last_name)
  end

  def name_parts(*parts)
    parts.map { |m| send(m) }.reject(&:blank?).join(" ")
  end
  
  before_create :create_invite_code
  
  
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!
    NotificationMailer.deliver_password_reset_instructions(self)
  end
  
  def deliver_invite_code!(account)
    create_invite_code
    NotificationMailer.deliver_user_invited_to_account(self, account)
  end
  
  private
  
  def stop_watching_brief(proposal)
    toggle_watch!(proposal.brief) if watching?(proposal.brief)
  end
  
  def create_invite_code
    if pending?
      transform = self.email.to_s + Time.now.to_s
      self.invite_code = Digest::MD5.hexdigest(transform) 
    end
  end

end
