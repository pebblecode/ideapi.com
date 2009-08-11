require 'md5'
class Invitation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id

  include Ideapi::Schizo

  state :pending, :default => true do
    # handle :publish! do
    #   transition_to :published
    #   save!
    # end
    # transition :to => :published, :on => :publish!, :if => proc { !brief_items.answered.empty? }
  end

  become_schizophrenic

  before_save :generate_code
  before_save :ensure_default_state
  
  validates_uniqueness_of :recipient_email, :scope => :user_id
  validates_format_of :recipient_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  private
  
  def generate_code
    transform = self.recipient_email.to_s
    self.code = Digest::MD5.hexdigest(transform) if !transform.blank?
  end

  class << self
    
    def from_list_into_hash(list, user)
      returning ({:successful => [], :failed => []}) do |invites|  
        from_list(list, user).each do |invite|
          if invite.valid?
            invites[:successful] << invite
          else
            invites[:failed] << invite
          end
        end
      end
    end
    
    def from_list(list, user)
      emails = list.split(/,|\s/).reject {|email| email.blank? }
      invites = []
      
      emails.each do |email|
        invites << self.create(:recipient_email => email, :user => user)
      end
      
      return invites
    end
  
  end

end
