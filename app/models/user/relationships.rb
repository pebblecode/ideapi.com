class User < ActiveRecord::Base

  # Authlogic settings
  # Handles authentication for the application
  # See - http://github.com/binarylogic/authlogic
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email 
    c.validate_email_field = false
    #c.validate_password_field = false
    c.merge_validates_confirmation_of_password_field_options(:unless => :pending?)
    c.merge_validates_length_of_password_confirmation_field_options(:unless => :pending?)
    c.merge_validates_length_of_password_field_options(:unless => :pending?)
  end

  # Paperclip attachment
  # See http://github.com/thoughtbot/paperclip
  has_attached_file :avatar, :styles => { 
    :large => "100x100>", :medium => "48x48>", :small => "32x32>" 
  }
  
  has_many :account_users, :dependent => :destroy 
  has_many :accounts, :through => :account_users
  
  # METHODS FOR BRIEF OWNERSHIP
  has_many :user_documents, :dependent => :destroy
  has_many :documents, :through => :user_documents

  # Used on User#show to add a user and permissions simultaenously
  # We reject anything that where all checkboxes are unchecked
  accepts_nested_attributes_for :user_documents,
    :reject_if => proc { |attrs| attrs['add_document'] == "0" && attrs['author'] == "0" && attrs['approver'] == "0" } 
  

  delegate :draft, :to => :documents
  delegate :published, :to => :documents
  
  # METHODS FOR WATCHING AND INTERACTING WITH A BRIEF
  has_many :questions
  has_many :proposals, :after_add => :stop_watching_document
  has_many :watched_documents, :dependent => :destroy
  
  # pathways to the hallowed documents
  has_many :responded_documents, :through => :proposals, :source => :document
  has_many :watching_documents, :through => :watched_documents, :source => :document

  has_many :authoring_documents, :class_name => "Document", :foreign_key => "author_id"
  has_many :approving_documents, :class_name => "Document", :foreign_key => "approver_id"
  has_many :collaborating_documents, :through => :user_documents, :source => :document, :conditions => ['author_id != #{self.id} AND approver_id != #{self.id}' ]
  
  alias :watching :watching_documents
  alias :pitching :responded_documents

  delegate :under_review, :to => :responded_documents
  delegate :complete, :to => :responded_documents
  
  belongs_to :invited_by, :class_name => "User"  
end
