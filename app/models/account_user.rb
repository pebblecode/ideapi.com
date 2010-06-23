require 'digest/md5'

class AccountUser < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :user
  
  before_destroy :ensure_enough_users_are_present
  
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
  
  named_scope :by_account, lambda { |account| {:conditions => ["account_id = ?", account]} }
  
  state :accepted
  state :cancelled
  
  become_schizophrenic

  before_save :generate_code
  before_save :ensure_default_state
  
  validates_presence_of :account
  validates_presence_of :user_id, :if => :accepted?
  validates_presence_of :code, :if => Proc.new { |account_user| account_user.pending? && account_user.user.blank? }
  validates_uniqueness_of :user_id, :scope => :account_id
  validates_uniqueness_of :account_id, :scope => :user_id
  
  #before_create :another_user_allowed?
    
  private
  
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
  
  def ensure_enough_users_are_present
    if self.class.admin.by_account(self.account).count <= 1 
      errors.add(:account, "You cannot remove only remaining admin")
    elsif self.class.by_account(self.account).count <= 1
       errors.add(:account, "You cannot remove an only remaining account user")
    end
  end
  
end
