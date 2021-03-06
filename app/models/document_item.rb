class DocumentItem < ActiveRecord::Base
  attr_accessor :send_notifications
  before_create :set_position
  after_update :deliver_notifications
  # Comments added by shapeshed for the good of developers everywhere
  # 
  # Document Items act as a clone of template questions so that we don't 
  # need to be concerned with template questions changing after a document 
  # has been created. 
  #
  # Document items are created when a document is created see the 
  # generate_document_items_from_template method
  # 
  # The acts_as_versioned gem is subsequently used to 
  # keep records of the changes to a document item. This means that if you make
  # changes to the model and you want these to be tracked by versioning 
  # you will also need to make them to document item versions

  # Relationships
  belongs_to :document, :touch => true
  has_many :questions, :dependent => :destroy
  has_many :timeline_events, :as => :secondary_subject, :order => 'created_at ASC, id ASC', :group => "subject_id, subject_type"
  
  validates_presence_of :title
  
  # Delegation takes some methods and sends them off to another 
  # model to be processed. This means if you want to debug something 
  # look in the model that it has been delegated to. Want more?
  # OK THEN! http://blog.wyeworks.com/2009/6/4/rails-delegate-method 
  delegate :published?, :to => :document
  delegate :author, :to => :document
  
  # Named scopes
  named_scope :answered, :conditions => 'body <> ""'
  # Added by George Ornbo. Incase the above is being used elsewhere adding a new one
  # to support headings as document items
  named_scope :answered_or_heading, :conditions => 'body <> "" OR is_heading = 1'
  
  # Gem Alert! For documentation see http://github.com/technoweenie/acts_as_versioned 
  acts_as_versioned :if_changed => [:body]
  
  # This method assumes that where the body of a document item is not 
  # blank that it has been answered.
  def answered?
    !body.blank?
  end
  
  
  # This method returns the total number of events (Section updates, questions, and answers)
  def total_activity_count
    return  self.timeline_events.find(:all, :conditions => {:event_type => "document_item_changed"}).length + 
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
  
  def current_user
    return User.current.nil? ? self.author : User.current
  end
 
  # This provides the ability to see when document items were changed 
  # via timeline_fu. There's probably a reason why this is on top of 
  # acts_as_versioned but it does look like this information is being
  # stored in two places
  # See timeline_fu - http://github.com/jamesgolick/timeline_fu 
  fires :document_item_changed, :on => :update,
                             :actor => 'current_user',
                             :subject => 'latest',
                             :secondary_subject => :self,
                             :log_level => 1,
                             :if => lambda { |item| 
                                              if item.latest.nil?
                                                false
                                              else
                                                item.published? and !item.body.eql?(item.latest.body)
                                              end
                                            }
  
  # This handles the versioning via acts_as_versioned
  # http://github.com/technoweenie/acts_as_versioned  
  class Version
    
    named_scope :revisions, 
      lambda { |document_item| 
        { 
          :conditions => [
            "version >= 1  AND body <> '' AND document_item_id = ?", 
            document_item.id
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

  # Sorting
  def self.order(ids)
    _ids = ids.join(',')
    update_all(
      ['position = FIND_IN_SET(id, ?)', _ids],
      { :id => ids }
    )
  end
  
  def set_position
    items = self.document.document_items
    if items.present?
      last_item = items.last
      self.position = last_item.position + 1 if last_item.position.present?
    end
  end
  
  def deliver_notifications
    recipients = self.document.users.reject(&:pending?).map(&:email)
    # remove current user's email and any nil or empty strings
    recipients -= [User.current.try(:email), nil, '']
    if self.send_notifications.to_i == 1
      if self.title_changed? or self.body_changed?
        NotificationMailer.deliver_document_section_updated(self.document.id, recipients, User.current.id, [self.id])
      end
    end
  rescue Errno::ECONNREFUSED
    nil
  end
end
