namespace :ideapi do
  
  desc "Bootstrap and rehash"
  task(:bootstrap  => :environment) do
    Rake::Task[ "db:drop" ].execute
    Rake::Task[ "db:create" ].execute
    Rake::Task[ "db:migrate" ].execute
    Rake::Task[ "db:seed" ].execute
    #Rake::Task[ "thinking_sphinx:rebuild" ].execute
  end
  
  task :build_cache => :environment do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::AssetTagHelper
    stylesheet_link_tag :all, :cache => true
  end

  desc "Backup current environment database and assets directory"
  task :backup => :environment do
    require 'lib/s3-backup.rb'
    SimpleS3Backup.do_backup
  end
end
