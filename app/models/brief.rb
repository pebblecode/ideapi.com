class Brief < ActiveRecord::Base

  # see each concern in brief/concern.rb
  concerned_with :activity_stream, 
    :formatting, 
    :relationships, 
    :roles, 
    :states, 
    :validation

  def account_name
    "pebble"
  end
  
  # INDEXING
  
  # define_index do 
  #   indexes title, most_important_message
  #   indexes brief_items.body, :as => :brief_items_content
  #   
  #   where "state = 'published'"
  #   
  #   set_property :delta => true
  # end
  
end
