class Brief < ActiveRecord::Base
  
  # see each concern in brief/concern.rb
  concerned_with :activity_stream, 
    :formatting, 
    :relationships, 
    :roles, 
    :states, 
    :validations
  
  def brief_items_changed?(hash)
    
    return false unless hash.is_a?(Hash)
    
    # Returns if any brief_item has changed. 
    # Check if it exists, and has changed. 
    # Builds an array of true / false values. True means an item has changed.
    # Returns true / false depending on the content of that array
    
    hash.collect{|k,v|
      item = BriefItem.find(:first, :conditions => {:id => k})
      item.blank? or item.body != v["body"]
    }.any?
  end
end