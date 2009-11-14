require 'md5'

class AccountUser < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :user
  
  include Ideapi::Schizo
  
  state :pending, :default => true do
    handle :redeem! do
      stored_transition_to(:accepted)
    end
    
    handle :cancel! do
      stored_transition_to(:cancelled)
    end    
  end
  
  named_scope :admin, :conditions => ["admin = ?", true]
  
  state :accepted
  state :cancelled
  
  become_schizophrenic

  before_save :generate_code
  before_save :ensure_default_state
  
  validates_presence_of :account
  validates_presence_of :user_id, :if => :accepted?
  validates_presence_of :code, :if => Proc.new { |account_user| account_user.pending? && account_user.user.blank? }
  
  #before_create :another_user_allowed?
    
  #private
  
  def generate_code
    transform = Time.now.to_s
    self.code = Digest::MD5.hexdigest(transform) if !transform.blank?
  end
  
  def another_user_allowed?
    if self.account && self.account.respond_to?(:user_limit) && self.account.respond_to?(:users)
      if (self.account.user_limit && self.account.users.count < self.account.user_limit) 
        return true
      else
        errors.add(:account, "User limit has been reached for this account")
        return false
      end
    else
      return true
    end
  end
  
end
