require 'capistrano/ext/multistage'
set :stages, %w(production staging)
 
server "174.143.232.121", :app, :web, :db, :primary => true
 
set :user, 'jason'
set :keep_releases, 3 
set :repository,  "git@abutcher.sourcerepo.com:abutcher/ideapi.git" 
set :use_sudo, false
set :scm, :git
set :deploy_via, :copy
 
# this will make sure that capistrano checks out the submodules if any
set :git_enable_submodules, 1
 
set(:application) { "ideapi_#{stage}" } # replace with your application name
set(:deploy_to) { "/home/#{user}/apps/#{application}" }
#set :copy_remote_dir, "/home/#{user}/tmp"
 
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
  task:migrate, :roles => :app do
    send(run_method, "cd #{current_path} && rake db:migrate RAILS_ENV=#{stage} ")     
  end
  
  desc "Link in the production database.yml" 
  task :after_update_code do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/uploads #{release_path}/public/uploads"
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/development.sqlite3 #{release_path}/db/development.sqlite3"
  end
  
end