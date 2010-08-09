class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.login_field = :email 
    c.validate_email_field = false
    #c.validate_password_field = false
    c.merge_validates_confirmation_of_password_field_options(:unless => :pending?)
    c.merge_validates_length_of_password_confirmation_field_options(:unless => :pending?)
    c.merge_validates_length_of_password_field_options(:unless => :pending?)
  end

  has_attached_file :avatar, :styles => { 
    :large => "100x100>", :medium => "48x48>", :small => "32x32>" 
  }
  
  has_many :account_users, :dependent => :destroy
  has_many :accounts, :through => :account_users
  
  # METHODS FOR BRIEF OWNERSHIP
  has_many :user_briefs, :dependent => :destroy
  has_many :briefs, :through => :user_briefs

  accepts_nested_attributes_for :user_briefs, 
    :reject_if => proc { |attrs| attrs['author'] == 0} 
  
  delegate :draft, :to => :briefs
  delegate :published, :to => :briefs
  
  # METHODS FOR WATCHING AND INTERACTING WITH A BRIEF
  has_many :questions
  has_many :proposals, :after_add => :stop_watching_brief
  has_many :watched_briefs, :dependent => :destroy
  
  # pathways to the hallowed briefs
  has_many :responded_briefs, :through => :proposals, :source => :brief
  has_many :watching_briefs, :through => :watched_briefs, :source => :brief
  
  alias :watching :watching_briefs
  alias :pitching :responded_briefs

  delegate :under_review, :to => :responded_briefs
  delegate :complete, :to => :responded_briefs
  
  belongs_to :invited_by, :class_name => "User"  
end
