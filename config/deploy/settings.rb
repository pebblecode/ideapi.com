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

set :default_stage, "staging"