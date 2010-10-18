server "apu.pebbleit.com", :app, :web, :db, :primary => true
set :user, "ideapi"
set(:deploy_to) { "/var/www/vhosts/ideapi.com/httpdocs" }
set :repository,  "git@apu.pebbleit.com:ideapi.com.git"
set :branch, "master"
set :deploy_via, :remote_cache


namespace :craken do
  desc "Install craken"
  task :install, :roles => :cron do
    set :raketab_rails_env, "staging"
    run "cd #{current_path} && rake app_name=#{application} deploy_path=#{current_path} RAILS_ENV=#{stage} craken:install"
  end
end
