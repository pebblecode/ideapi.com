server "apu.pebbleit.com", :app, :web, :db, :primary => true
set :user, "ideapi"
set(:deploy_to) { "/var/www/vhosts/ideapi.com/httpdocs" }
set :repository,  "git@apu.pebbleit.com:ideapi.com.git"
set :branch, "master"
set :deploy_via, :remote_cache