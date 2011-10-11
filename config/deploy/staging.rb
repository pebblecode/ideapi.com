server "apu.pebbleit.com", :app, :web, :db, :primary => true
set :user, "ideapi"
set(:deploy_to) { "/var/www/vhosts/ideapi.com/httpdocs" }
set :repository,  "git@apu.pebbleit.com:ideapi.com.git"
set :branch, "master"
set :deploy_via, :remote_cache
role :cron, "apu.pebbleit.com"

set :default_environment, {
  'PATH' => "/home/ideapi/.rbenv/shims:/home/ideapi/.rbenv/bin:$PATH"
}

namespace :deploy do

  task :start do
    run "cd #{release_path} &&  RAILS_ENV=#{stage} bundle exec thin -C config/thin/staging.yml start"
  end
  task :stop do
    run "cd #{release_path} &&  RAILS_ENV=#{stage} bundle exec thin -C config/thin/staging.yml stop"
  end
  task :restart do
    run "cd #{release_path} &&  RAILS_ENV=#{stage} bundle exec thin -C config/thin/staging.yml restart"
  end 

end

namespace :craken do
  desc "Install craken"
  task :install, :roles => :cron do
    set :raketab_rails_env, "staging"
    run "cd #{current_path} && rake app_name=#{application} deploy_path=#{current_path} RAILS_ENV=#{stage} craken:install"
  end
end
