server "174.143.232.121", :app, :web, :db, :primary => true
set :user, "jason"
set :branch, "production"
set :deploy_via, :remote_cache
role :cron, "174.143.232.121"

namespace :craken do
  desc "Install craken"
  task :install, :roles => :cron do
    set :raketab_rails_env, "staging"
    run "cd #{current_path} && rake app_name=#{application} deploy_path=#{current_path} RAILS_ENV=#{stage} craken:install"
  end
end
