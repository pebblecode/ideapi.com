class Brief < ActiveRecord::Base
  
  # see each concern in brief/concern.rb
  concerned_with :activity_stream, 
    :formatting, 
    :relationships, 
    :roles, 
    :states, 
    :validations
  
  def brief_items_changed?(hash)
    # Returns changed brief_items
    raise "Method expects a Hash" unless hash.is_a?(Hash)
    hash.collect{|k,v| item = BriefItem.find(:first, :conditions => ["id = ? AND body != ?", k, v["body"]]) }.compact
  end
end