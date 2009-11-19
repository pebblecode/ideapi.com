class Brief < ActiveRecord::Base

  # see each concern in brief/concern.rb
  concerned_with :activity_stream, 
    :formatting, 
    :relationships, 
    :roles, 
    :states, 
    :validations
   
end
