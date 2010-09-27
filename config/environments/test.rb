APPLICATION_URL = "http://smackaho.st/"
# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
# config.action_mailer.delivery_method = :test

# require "smtp-tls"
ActionMailer::Base.smtp_settings = {
  :tls => true,
  :address => "smtp.gmail.com",
  :port => "587",
  :domain => "ideapi.net",
  :authentication => :plain,
  :user_name => "dev@ideapi.net",
  :password => "createarevolution$"
}

ActionMailer::Base.delivery_method = :sendmail

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

config.gem "faker"
config.gem "shoulda", :version => "2.10.3"
config.gem "machinist"
config.gem "webrat", :version => "0.7.0"
config.gem "cucumber-rails", :lib => false
config.gem "spork", :lib => false
config.gem "capybara", :lib => false
config.gem 'rspec', :lib => false
config.gem 'rspec-rails', :lib => false
config.gem "factory_girl", :lib => false
config.gem 'email_spec', :lib => false, :version => "0.6.2"
config.gem 'rspec', :lib => false
config.gem 'test-unit', :lib => false
config.gem 'database_cleaner', :lib => false
config.gem 'launchy', :lib => false

config.after_initialize do
  ActiveMerchant::Billing::Base.gateway_mode = :test
end
