# Settings specified here will take precedence over those in config/environment.rb
APPLICATION_URL = "http://vcap.me/"

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true
config.action_controller.session = { :domain => ".vcap.me" }
# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

Haml::Template.options[:ugly] = true

# config.after_initialize do
#   ActiveMerchant::Billing::Base.gateway_mode = :test
# end

# ActionMailer::Base.smtp_settings = {
#   :tls => true,
#   :address => "smtp.gmail.com",
#   :port => "587",
#   :domain => "ideapi.net",
#   :authentication => :plain,
#   :user_name => "dev@ideapi.net",
#   :password => "createarevolution$"
# }

# config.gem 'bullet', :source => 'http://gemcutter.org'
# config.after_initialize do
#   Bullet.enable = true 
#   Bullet.alert = true
#   Bullet.bullet_logger = true  
#   Bullet.console = true
#   begin
#     require 'ruby-growl'
#     Bullet.growl = true
#   rescue MissingSourceFile
#   end
#   Bullet.rails_logger = true
#   Bullet.disable_browser_cache = true
# end
config.action_mailer.delivery_method = :file
Paperclip.options[:command_path] = '/usr/local/bin'
