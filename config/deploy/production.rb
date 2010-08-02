server "174.143.232.121", :app, :web, :db, :primary => true
set :user, "jason"
set :branch, "production"
set :repository,  "git@apu.pebbleit.com:ideapi.com.git"
set :deploy_via, :remote_cache
