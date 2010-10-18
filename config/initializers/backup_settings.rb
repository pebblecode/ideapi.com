require 'aws/s3'

def find_cmd(cmd)
  return `which #{cmd}`.gsub("//", "/").strip
end

# EXECUTABLES
MYSQLDUMP_CMD = find_cmd("mysqldump")
GZIP_CMD = find_cmd("gzip")
TAR_CMD =find_cmd("tar")
CP_CMD = find_cmd("cp")
S3SYNC_CMD = "#{RAILS_ROOT}/script/s3sync/s3sync.rb"
# PATHS
TMP_BACKUP_PATH = "#{RAILS_ROOT}/tmp/backup" # Will be created (and removed) inside the directory where the script is installed

# CREATE AWS/S3 CONNECTION
S3_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/s3config.yml")

AWS::S3::Base.establish_connection!(
  :access_key_id  => S3_CONFIG['AWS_ACCESS_KEY_ID'],
  :secret_access_key => S3_CONFIG['AWS_SECRET_ACCESS_KEY']
)

# SPECIFY S3 BUCKET
S3_BUCKET = 'backups.ideapi.' + RAILS_ENV

# SPECIFY HOW MANY DAYS OF ARCHIVES YOU WANT TO KEEP
DAYS_OF_ARCHIVES = 7

# MYSQL CONFIG
#  * Put the MySQL table names that you want to back up in the MYSQL_DBS array below
#    Archive will be named in the format: db-table_name-200912010423.tgz
#    where 200912010423 is the date/time when the script is run
MYSQL_DBS = [ActiveRecord::Base.configurations[RAILS_ENV]['database']]
MYSQL_DB = 'localhost'
MYSQL_USER = ActiveRecord::Base.configurations[RAILS_ENV]['username']
MYSQL_PASS = ActiveRecord::Base.configurations[RAILS_ENV]['password']

# DIRECTORY BACKUP CONFIG
DIRECTORIES = {
  "assets" => "#{RAILS_ROOT}/public/assets"
}
