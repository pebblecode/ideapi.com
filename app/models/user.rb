class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end
  
  has_many :briefs
  has_many :creative_responses
  has_many :comments 
  
end
