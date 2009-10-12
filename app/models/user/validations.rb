class User < ActiveRecord::Base
  
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
  
  
  # protect against mass assignment
  attr_accessible :login, 
    :email, 
    :avatar_file_name, 
    :avatar_content_type, 
    :avatar_file_size, 
    :avatar_updated_at, 
    :last_login_at, 
    :last_request_at, 
    :password, 
    :password_confirmation, 
    :avatar, 
    :first_name, 
    :last_name
  
end