namespace :ci do
  task :copy_yml do
    system("cp #{Rails.root}/config/database.yml.ci #{Rails.root}/config/database.yml")
  end

  desc "Prepare for CI and run entire test suite"
  task :build => ['ci:copy_yml', 'db:migrate', 'test'] do
  
  end
end