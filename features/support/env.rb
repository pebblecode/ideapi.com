require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require 'machinist'
  require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper')
  require File.expand_path(File.dirname(__FILE__) + '/../../test/blueprints')
  
  ENV["RAILS_ENV"] ||= "cucumber"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
  require 'cucumber/rails/world'
  require 'cucumber/rails/active_record'
  require 'cucumber/web/tableish'
  require 'email_spec'
  require 'email_spec/cucumber'



  require 'capybara/rails'
  require 'capybara/cucumber'
  require 'capybara/session'
  require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript
  Capybara.default_selector = :css  
  Capybara.default_host = "smackaho.st"
  Capybara.app_host = "smackaho.st"
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Cucumber::Rails::World.use_transactional_fixtures = true
  # How to clean your database when transactions are turned off. See
  # http://github.com/bmabey/database_cleaner for more info.
  # if defined?(ActiveRecord::Base)
  #   begin require 'database_cleaner'
  #     DatabaseCleaner.strategy = :truncation
  #   rescue LoadError => ignore_if_database_cleaner_not_present
  #   end
  # end
end

Before do

end
 
