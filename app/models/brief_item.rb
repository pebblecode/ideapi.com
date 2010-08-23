class BriefItem < ActiveRecord::Base
  
  # Comments added by shapeshed for the good of developers everywhere
  # 
  # Brief Items act as a clone of template questions so that we don't 
  # need to be concerned with template questions changing after a brief 
  # has been created. 
  #
  # Brief items are created when a brief is created see the 
  # generate_brief_items_from_template method
  # 
  # The acts_as_versioned gem is subsequently used to 
  # keep records of the changes to a brief item. This means that if you make
  # changes to the model and you want these to be tracked by versioning 
  # you will also need to make them to brief item versions

  # Relationships
  belongs_to :brief, :touch => true
  has_many :questions
  has_many :timeline_events, :as => :secondary_subject, :order => 'created_at ASC, id ASC', :group => "subject_id, subject_type"
  
  # Delegation takes some methods and sends them off to another 
  # model to be processed. This means if you want to debug something 
  # look in the model that it has been delegated to. Want more?
  # OK THEN! http://blog.wyeworks.com/2009/6/4/rails-delegate-method 
  delegate :published?, :to => :brief
  delegate :author, :to => :brief
  
  # Named scopes
  named_scope :answered, :conditions => 'body <> ""'
  # Added by George Ornbo. Incase the above is being used elsewhere adding a new one
  # to support headings as brief items
  named_scope :answered_or_heading, :conditions => 'body <> "" OR is_heading = 1'
  
  # Gem Alert! For documentation see http://github.com/technoweenie/acts_as_versioned 
  acts_as_versioned :if_changed => [:body]
  
  # This method assumes that where the body of a brief item is not 
  # blank that it has been answered.
  def answered?
    !body.blank?
  end
  
  
  # This method returns the total number of events (Section updates, questions, and answers)
  def total_activity_count
    return  self.timeline_events.find(:all, :conditions => {:event_type => "brief_item_changed"}).count + 
            self.questions.count +
            self.questions.answered.count
  end
  # Tell acts_as_versioned to exclude certain columns 
  self.non_versioned_columns << 'updated_at'
  self.non_versioned_columns << 'created_at'

  # Shorthand method to get the latest revision
  def latest
    revisions.latest
  end
 
  # This provides the ability to see when brief items were changed 
  # via timeline_fu. There's probably a reason why this is on top of 
  # acts_as_versioned but it does look like this information is being
  # stored in two places
  # See timeline_fu - http://github.com/jamesgolick/timeline_fu 
  fires :brief_item_changed, :on => :update,
                             :actor => 'author',
                             :subject => 'latest',
                             :secondary_subject => :self,
                             :log_level => 1,
                             :if => lambda { |item| item.published? && !item.revisions.blank? && !item.body.eql?(item.latest.body) }
  
  # This handles the versioning via acts_as_versioned
  # http://github.com/technoweenie/acts_as_versioned  
  class Version
    
    named_scope :revisions, 
      lambda { |brief_item| 
        { 
          :conditions => [
            "version > 1 AND body <> '' AND brief_item_id = ?", 
            brief_item.id
          ] 
        }
      } do      
      
      # METHODS SCOPED INSIDE REVISIONS
      def latest
        self.last
      end

    end
    
    include Ideapi::GetParsed
    gp_parse_fields :body
    
  end
  
  def revisions
    Version.revisions(self)
  end
  
  # FORMATTING
  include Ideapi::GetParsed
  gp_parse_fields :body
  truncates :title
  
end
