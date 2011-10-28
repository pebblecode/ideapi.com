class Document < ActiveRecord::Base
  
  attr_accessor :send_notifications
  
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

  # BOOL Returns true if this document has any proposals (ideas). False otherwise.
  def has_proposals?
    self.proposals.any?
  end
end