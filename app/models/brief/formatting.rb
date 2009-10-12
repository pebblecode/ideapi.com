class Brief < ActiveRecord::Base
  
  # see plugin totally_truncated
  truncates :title

end