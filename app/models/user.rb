class User < ActiveRecord::Base

  acts_as_authentic do |c|
    #c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
  end
  
  has_many :comments 
  
  @comment_freshness = 5.minutes
  class << self; attr_accessor :comment_freshness; end
  
  def commented_recently?
    time = User.comment_freshness(&:db)
    comments.first(:conditions => ["created_at > ? || updated_at > ?", time, time]).blank?
  end
  
end
