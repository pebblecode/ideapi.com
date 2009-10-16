server "192.168.3.4", :app, :web, :db, :primary => true
set :user, "developer"
set(:deploy_to) { "/Users/#{user}/Sites/#{application}" }
set :branch, "master"