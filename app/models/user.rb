class User < ActiveRecord::Base

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end

  has_attached_file :avatar, :styles => { :large => "100", :medium => "48x48>", :small => "32x32>" }

  # class User < ActiveRecord::Base
  class_eval do
    %w(creative author).each do |klass|
      define_method("#{klass}?") do
        return (self.class.to_s.downcase == klass)
      end
    end
  end
  
end
