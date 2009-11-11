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
    
  private
  
  def generate_code
    transform = Time.now.to_s
    self.code = Digest::MD5.hexdigest(transform) if !transform.blank?
  end
  
end
