class Brief < ActiveRecord::Base
  belongs_to :brief_config
  belongs_to :user
  
  validates_presence_of :user, :brief_config
end
