if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, Ideapi::Config)
end