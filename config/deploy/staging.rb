server "ralph.local", :app, :web, :db, :primary => true
set(:deploy_to) { "/Users/#{user}/apps/#{application}" }
set :branch, "master"