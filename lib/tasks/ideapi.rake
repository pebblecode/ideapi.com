namespace :ideapi do
  
  desc "Bootstrap and rehash"
  task(:bootstrap  => :environment) do
    `rake db:drop`
    `rake db:create`
    `rake db:migrate`
    `rake db:seed`
    `rake db:seed`
  end
  
end
