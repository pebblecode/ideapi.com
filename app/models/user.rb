class User < ActiveRecord::Base

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end

  has_attached_file :avatar, :styles => { :medium => "48x48>", :small => "32x32>" }  
end
