class Document < ActiveRecord::Base
  
  # see each concern in document/concern.rb
  concerned_with :activity_stream, 
    :formatting, 
    :relationships, 
    :roles, 
    :states, 
    :validations
  
  def document_items_changed?(hash)
    # Returns changed document_items
    raise "Method expects a Hash" unless hash.is_a?(Hash)
    hash.collect{|k,v| item = DocumentItem.find(:first, :conditions => ["id = ? AND body != ?", k, v["body"]]) }.compact
  end
end