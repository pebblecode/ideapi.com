source 'http://rubygems.org'

gem 'rails', '2.3.9'
gem 'mysql'
gem 'capistrano'
gem 'capistrano-ext'
gem 'resque'
gem 'resque_mailer' #resque/tasks required in Rakefile
gem 'haml'
gem 'rdiscount' # markdown
gem 'authlogic'
gem 'will_paginate'
gem 'acts-as-taggable-on', '2.0.0.rc1'
gem 'SystemTimer'
gem "alter-ego", :require => "alter_ego"
gem "RedCloth", "4.2.5"
gem 'hoptoad_notifier'
gem 'aws-s3', :require => "aws/s3"
gem 'ci_reporter'
gem "compass", ">= 0.10.6"

group :staging do 
  gem "faker"
  gem "shoulda", "2.10.3"
  gem "machinist"
  gem "webrat", "0.7.0"
  gem "cucumber"
end

group :test do 
  gem "faker"
  gem "shoulda", "2.10.3"
  gem "machinist"
  gem "webrat", "0.7.0"
  gem "gherkin"
  gem "cucumber-rails", "~> 0.3.2"
  gem "spork"
  gem "capybara", "0.3.9"
  gem 'rspec-rails'
  gem "factory_girl"
  gem 'email_spec', "0.6.2"
  gem 'rspec'
  gem 'test-unit'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'ruby-debug'
end
