require 'capistrano/ext/multistage'

# basics
load 'config/deploy/settings'
 
# deployment tasks
load 'config/deploy/symlinks'
 
# source: http://tomcopeland.blogs.com/juniordeveloper/2008/05/mod_rails-and-c.html
# source: http://github.com/blog/470-deployment-script-spring-cleaning
namespace :deploy do
  
  desc "Deploy the MFer"
  task :default do
    update
    restart
    cleanup
  end
 
  desc "Setup a GitHub-style deployment."
  task :setup, :except => { :no_release => true } do
    run "git clone #{repository} #{current_path}"
  end
 
  desc "Update the deployed code."
  task :update_code, :except => { :no_release => true } do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
  end
 
  desc "Rollback a single commit."
  task :rollback, :except => { :no_release => true } do
    set :branch, "HEAD^"
    default
  end
  
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
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/#{stage}.sphinx.conf #{release_path}/config/#{stage}.sphinx.conf" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/uploads #{release_path}/public/uploads"
  end
  
  desc "Rebuild the db and setup sample data for ideapi"
  task :bootstrap do
    send(run_method, "cd #{current_path} && rake ideapi:bootstrap RAILS_ENV=#{stage} ")
  end
  
end

