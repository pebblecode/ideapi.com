#require 'friendship'
require 'digest/md5'

class User < ActiveRecord::Base
  validates_acceptance_of :terms_of_service, :message => "Must accept the Terms and Conditions", :accept => "1"
  attr_accessible :terms_of_service
  
  #getting current user from other models (set in application controller)
  cattr_accessor :current
  
  # Defines an instance variable so we can send a custom
  # invitation message
  attr_accessor :invitation_message, :can_create_documents
  
  concerned_with :documents,
    :class_methods,
    :relationships,  
    :validations
    
  # users are found by username
  def to_param
    self.screename || self.id.to_s
  end
  
  # called from proposal_observer
  def proposal_created(proposal)
    stop_watching_document(proposal)
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
    #[DEPRECATED]
    # NotificationMailer.deliver_password_reset_instructions(self, self.accounts.first)
    # We are sending mail jobs to Resque now so need to send the id
    # so workers can handle it
    begin
      NotificationMailer.deliver_password_reset_instructions(self.id, self.accounts.first.id)
    rescue Errno::ECONNREFUSED
      nil
    end
  end
  
  def deliver_invite_code!(account)
    create_invite_code
    #[DEPRECATED]
    # NotificationMailer.deliver_user_invited_to_account(self, account)
    begin
      NotificationMailer.deliver_user_invited_to_account(self.id, account.id, "")
    rescue Errno::ECONNREFUSED
      nil
    end
  end

  
  #############################################################################  
  # Account properties
  ############################################################################# 
  
  # Note: can't call it accounts as it clashes with active record 
  def account_properties
    accounts = Account.find_by_sql("SELECT a.name, a.full_domain, au.admin as is_admin, au.can_create_documents
                  FROM accounts as a                  
                  LEFT JOIN account_users as au 
                  ON a.id = au.account_id
                  WHERE au.user_id = #{self.id}");
    
    return accounts
  end
  
  #############################################################################  
  # Documents
  ############################################################################# 
  
  def num_documents_created
    return Document.find(:all, :conditions => ["author_id = ?", self.id]).size
  end

  # ie, In the user documents table, and an author
  def num_documents_as_author
    return UserDocument.find(:all, :conditions => ["user_id = ? AND author = '1'", self.id]).size
  end
  
  def num_documents_as_approver    
    return Document.find(:all, :conditions => ["approver_id = ?", self.id]).size
  end  

  # ie, In the user documents table, but not an author
  def num_documents_as_collaborator_only
    return UserDocument.find(:all, :conditions => ["user_id = ? AND author = '0'", self.id]).size
  end  
  
  # ie, Number of documents in the user documents table
  def total_num_documents
    return UserDocument.find(:all, :conditions => ["user_id = ?", self.id]).size
  end  
  
  def total_number_of_documents_last_week
    # return total_number_of_documents_val("week")
    return UserDocument.find(:all, :conditions => ["user_id = ? AND (created_at > (NOW() - INTERVAL 1 WEEK))", self.id]).size
  end  
  
  def total_number_of_documents_last_month
    return UserDocument.find(:all, :conditions => ["user_id = ? AND (created_at > (NOW() - INTERVAL 1 MONTH))", self.id]).size
  end  
  
  private
  
  def stop_watching_document(proposal)
    toggle_watch!(proposal.document) if watching?(proposal.document)
  end
  
  def create_invite_code
    if pending?
      transform = self.email.to_s + Time.now.to_s
      self.invite_code = Digest::MD5.hexdigest(transform) 
    end
  end

end
