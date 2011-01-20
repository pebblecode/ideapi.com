class Document < ActiveRecord::Base

  # ACTIVITY STREAM
  fires :document_created, :on => :create, :actor => "author", :log_level => 1
  fires :document_updated, :on => :update, :actor => "author", :log_level => 1, :if => :published?
  
  def timeline_events(options = {})
    options.reverse_merge! :conditions => ["log_level >=1 AND created_at >= ?", 1.day.ago], :include_document_items => false, :order => 'created_at ASC, id ASC'
    if options.delete(:include_document_items)
      TimelineEvent.document_history_with_document_items(self).all(options)
    else
      TimelineEvent.document_history(self).all(options)
    end
  end
      
  cattr_accessor :timeline_log_level
  class << self; @@timeline_log_level = 1; end
  
  cattr_accessor :timeline_since
  class << self; @@timeline_since = Time.now(&:db); end
  
end