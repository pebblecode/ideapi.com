require 'md5'
class Invitation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id
  belongs_to :redeemed_by, :class_name => "User", :foreign_key => "redeemed_by_id"
  belongs_to :redeemable, :polymorphic => true
  
  include Ideapi::Schizo
  
  state :pending, :default => true do
    handle :redeem! do
      stored_transition_to(:accepted)
    end
    
    handle :cancel! do
      stored_transition_to(:cancelled)
    end    
  end
  
  state :accepted
  state :cancelled
  
  become_schizophrenic

  before_save :generate_code
  before_save :ensure_default_state
  before_create :check_for_existing_system_user
  
  attr_accessor :recipient_list
  
  validates_uniqueness_of :recipient_email, :scope => :user_id
  validates_format_of :recipient_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  validate :reedemable_item_must_belong_to_user
  
  def reedemable_item_must_belong_to_user
    errors.add_to_base("Must own the #{redeemable_type} you invite people to view") unless (redeemable.blank? || user.owns?(redeemable))
  end
  
  def redeem_for_user(user)
    transaction do
      self.code = ""
      self.redeemed_at = Time.zone.now
      self.redeemed_by = user
      self.redeem!
    end
    
    return self.accepted?
  end
    
  private
  
  def generate_code
    transform = self.recipient_email.to_s + Time.now.to_s
    self.code = Digest::MD5.hexdigest(transform) if !transform.blank?
  end
  
  def check_for_existing_system_user
    self.existing_user = User.find_by_email(self.recipient_email).present?
  end

  class << self
    
    def from_list_into_hash(params, user)
      list = params.delete(:recipient_list)
      
      returning ({:successful => [], :failed => []}) do |invites|  
        from_list(list, user, params).each do |invite|
          if invite.valid?
            invites[:successful] << invite
          else
            invites[:failed] << invite
          end
        end
      end
    end
    
    def from_list(list, user, params)
      emails = list.split(/,|\s/).reject {|email| email.blank? }
      invites = []
      
      emails.each do |email|
        invites << self.create({:recipient_email => email, :user => user}.reverse_merge(params))
      end
      
      return invites
    end
  
  end

end
