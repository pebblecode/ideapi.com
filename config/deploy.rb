require 'capistrano/ext/multistage'
set :stages, %w(production staging)
  
set :user, 'jason'
set :keep_releases, 3 
set :repository,  "git@apu.pebbleit.com:ideapi.com.git"
set :use_sudo, false
set :scm, :git
set :deploy_via, :copy
 
# this will make sure that capistrano checks out the submodules if any
set :git_enable_submodules, 1
 
set(:application) { "ideapi_#{stage}" } # replace with your application name
set(:deploy_to) { "/home/#{user}/apps/#{application}" }
#set :copy_remote_dir, "/home/#{user}/tmp"

set :default_stage, "staging"
 
# source: http://tomcopeland.blogs.com/juniordeveloper/2008/05/mod_rails-and-c.html
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "invoke the db migration"
  task :migrate, :roles => :app do
    send(run_method, "cd #{current_path} && rake db:migrate RAILS_ENV=#{stage} ")     
  end
  
  desc "Link in the production database.yml" 
  task :link_config_files do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/#{stage}.sphinx.conf #{release_path}/config/#{stage}.sphinx.conf" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/gateway.yml #{release_path}/config/gateway.yml"
    #run "ln -nfs #{deploy_to}/#{shared_dir}/config/paypal.yml #{release_path}/config/paypal.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/uploads #{release_path}/public/uploads"
  end
  
  desc "Rebuild the db and setup sample data for ideapi"
  task :bootstrap do
    send(run_method, "cd #{current_path} && rake ideapi:bootstrap RAILS_ENV=#{stage} && rake db:bootstrap")
  end
  
  task :prepare_static_cache do
    # SASS -> CSS -> all.css; all.js
    send(run_method, "cd #{release_path}; rake RAILS_ENV=#{stage} ideapi:build_cache")
  end
  
  desc "Restart monit for the ideapi group"
  task :restart_monit do    
    sudo "/usr/sbin/monit -g ideapi restart all"  
  end

end

after "deploy:update_code", "deploy:link_config_files", "deploy:restart_monit"



Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
