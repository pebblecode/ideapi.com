#!/usr/bin/env ruby

# Add local directory to LOAD_PATH
%w(rubygems aws/s3 fileutils).each do |lib|
  require lib
end
include AWS::S3

require 'config/initializers/backup_settings'

class SimpleS3Backup

  def self.do_backup
    
    #########################################################
    # Backs up the mysql database and folders. 
    # There are two config files that must exist for this to work: 
    #   1. config/s3config.yml :  contains AWS key and secret_key for 
    #                             both s3sync.rb and this script 
    #                             to authenticate correctly
    #   2. config/initializers/backup_settings.rb: commands are configured 
    #                             here, as well as DIRECTORIES.
    #
    # You must specify the directories you want to backup as a hash in the
    # configuration file.
    #########################################################
    
    # Initial setup
    timestamp = Time.now.strftime("%Y%m%d-%H%M")
    full_tmp_path = File.join(File.expand_path(File.dirname(__FILE__)), TMP_BACKUP_PATH)

    # Find/create the backup bucket
    if Service.buckets.collect{ |b| b.name }.include?(S3_BUCKET)
      bucket = Bucket.find(S3_BUCKET)
    else
      begin
        bucket = Bucket.create(S3_BUCKET)
      rescue Exception => e
        puts "There was a problem creating the bucket: #{e.message}"
        exit
      end
    end

    # Create tmp directory
    FileUtils.mkdir_p full_tmp_path

    # Perform directory backups
    if DIRECTORIES && DIRECTORIES.length > 0
      DIRECTORIES.each do |name, dir|
        system("export S3CONF=#{RAILS_ROOT}/config && #{S3SYNC_CMD} -r #{dir}/ #{S3_BUCKET}:#{name}")
      end
    end

    # Perform MySQL backups
    if MYSQL_DBS && MYSQL_DBS.length > 0
      MYSQL_DBS.each do |db|
        db_filename = "db-#{db}-#{timestamp}.gz"
        pwd = "-p#{MYSQL_PASS}" if MYSQL_PASS
        system("#{MYSQLDUMP_CMD} -u #{MYSQL_USER} #{pwd} --single-transaction --add-drop-table --add-locks --create-options --disable-keys --extended-insert --quick #{db} | #{GZIP_CMD} -c > #{full_tmp_path}/#{db_filename}")
        S3Object.store(db_filename, open("#{full_tmp_path}/#{db_filename}"), S3_BUCKET)
      end
    end
    

    # Remove tmp directory
    FileUtils.remove_dir full_tmp_path

    # Now, clean up unwanted archives
    cutoff_date = Time.now.utc.to_i - (DAYS_OF_ARCHIVES * 86400)
    bucket.objects.select{ |o| o.last_modified.to_i < cutoff_date }.each do |f|
      S3Object.delete(f.key, S3_BUCKET)
    end

  end

end