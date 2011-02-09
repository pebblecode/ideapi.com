# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.gem "haml"
  # config.gem "authlogic"
  # config.gem "alter-ego", :lib => "alter_ego"
  
  # config.gem "will_paginate", :lib => "will_paginate"
  # config.gem "RedCloth"
  # config.gem "acts-as-taggable-on", :source => "http://gemcutter.org", :version => '2.0.0.rc1'
  # config.gem 'hoptoad_notifier'
  # config.gem 'resque' 
  # config.gem 'resque_mailer'
  # config.gem 'SystemTimer', :lib => 'system_timer'
  # config.gem "rdiscount", :source => 'http://gemcutter.org' # For Markdown  
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks
  config.frameworks -= [ :active_resource ]

  # Activate observers that should always be running
  # config.active_record.observers = :proposal_observer

  # Set Time.zone 
  config.time_zone = 'London'
  require "alter_ego"
end

# override the default rails error wrapper (div) until this patch gets applied
# https://rails.lighthouseapp.com/projects/8994/tickets/1626
ActionView::Base.field_error_proc = 
           Proc.new{ |html_tag, instance| "<span class=\"field_with_errors\">#{html_tag}</span>" }
Sass::Plugin.options[:style] = :compact