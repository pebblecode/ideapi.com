class Brief < ActiveRecord::Base

  # ACTIVITY STREAM
  fires :brief_created, :on => :create, :actor => "author", :log_level => 1
  fires :brief_updated, :on => :update, :actor => "author", :log_level => 1, :if => :published?
  
  def timeline_events(options = {})
    options.reverse_merge! :conditions => ["log_level >=1 AND created_at >= ?", 1.day.ago], :include_brief_items => false, :order => 'created_at DESC'
    if options.delete(:include_brief_items)
      TimelineEvent.brief_history_with_brief_items(self).all(options)
    else
      TimelineEvent.brief_history(self).all(options)
    end
  end
      
  cattr_accessor :timeline_log_level
  class << self; @@timeline_log_level = 1; end
  
  cattr_accessor :timeline_since
  class << self; @@timeline_since = Time.now(&:db); end
  
end