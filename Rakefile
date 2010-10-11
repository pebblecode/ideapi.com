# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rubygems'
gem 'ci_reporter'
require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
require 'ci/reporter/rake/cucumber'  # use this if you're using Cucumber
require 'ci/reporter/rake/test_unit' # use this if you're using Test::Unit

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'resque/tasks'

require 'tasks/rails'

namespace :test do
  desc 'Measures test coverage'
  task :coverage do
    require 'shoulda/tasks'
    
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov -Itest --rails --aggregate coverage.data -T -x \" rubygems/*,/Library/Ruby/Site/*,gems/*,rcov*\""
    system("#{rcov} --no-html test/unit/*_test.rb test/unit/helpers/*_test.rb")
    system("#{rcov} --no-html test/functional/*_test.rb")
    system("#{rcov} --html test/integration/*_test.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
end
