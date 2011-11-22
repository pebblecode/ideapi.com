server "apu.pebbleit.com", :app, :web, :db, :primary => true
set :user, "ideapi"
set(:deploy_to) { "/var/www/vhosts/ideapi.com/httpdocs" }
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

  desc "Link in the production database.yml" 
  task :link_config_files do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{deploy_to}/#{shared_dir}/tmp/sockets #{release_path}/tmp/sockets"
  end

end

