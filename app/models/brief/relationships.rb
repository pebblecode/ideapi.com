require 'set'

class Brief < ActiveRecord::Base

  # The acts-as-taggable handles tags on the model
  # See http://github.com/mbleigh/acts-as-taggable-on
  acts_as_taggable

  # acts_as_taggable isn't quite as flexible as we need
  # it to be so this virutal attribute allows some post 
  # processing on form submissions. See the after_create 
  # and after_update filters in the controller. 
  attr_accessor :tag_field


  # RELATIONSHIPS
  
  # TEMPLATE BRIEF 
  # this builds the template sections
  # that the brief author is presented 
  # with when creating the brief
  
  belongs_to :account
  belongs_to :template_brief
  after_create :generate_brief_items_from_template!

  # BRIEF ITEMS
  has_many :brief_items, :order => 'position ASC, created_at ASC, id ASC'
  
  accepts_nested_attributes_for :brief_items, 
    :allow_destroy => true, 
    :reject_if => :all_blank
    
  has_many :brief_items_answered, 
    :class_name => 'BriefItem', 
    :conditions => ['brief_items.body <> ""'], 
    :order => :position
    
  # RELATIONSHIP WITH USERS
  has_many :user_briefs do
    def for_user(user)
      first :conditions => ['user_id = ?', user]
    end
  end
  
  accepts_nested_attributes_for :user_briefs, 
    :allow_destroy => true
  
  before_update :check_for_author_deletion, :check_for_last_author_removal
  
  def check_for_author_deletion
    author_guard = self.user_briefs.select {|ub| ub.marked_for_destruction? && ub.user == self.author }
      
    if author_guard.present?
      errors.add(:user_briefs, "You cannot remove the brief author from a brief")
      return false
    end
  end
  
  def check_for_last_author_removal
    if (self.user_briefs.authored.count == 1) && self.user_briefs.authored.any?(&:marked_for_destruction?)
      errors.add(:user_briefs, "You cannot remove the only author from a brief")
      return false
    end
  end
  
  has_many :users, :through => :user_briefs
  delegate :authors, :to => :users
  
  # convience methods for finding users to add to a brief
  def available_collaborators
    Set[*self.account.users].difference(self.users).to_a
  end

  def available_collaborators_attributes=(attributes)
    self.users << User.find(attributes[:user_ids])
  end
  
  # POINTERS TO SPECIAL USERS
  belongs_to :author, :class_name => 'User'
  after_create :add_author_to_authors
  
  belongs_to :approver, :class_name => 'User'

  # INVITATIONS
  has_many :invitations, :as => :redeemable

  has_many :proposals
  has_many :questions
  
  # COMMENTS
  acts_as_commentable  

  named_scope :by_account, lambda { |account, options| 
    { :conditions => ["briefs.account_id = ?", account.id] }
  }

  # Tests are whining at this named scope switching to simple ordering for now
  named_scope :ordered, lambda { |order| {:order => order || "updated_at DESC"} }
  # named_scope :ordered, :order => "updated_at DESC"
  def clean_brief!
    self.questions.destroy_all
    self.comments.destroy_all
    self.timeline_events().each{|event| event.destroy}
    self.brief_items.each{|item| item.timeline_events.destroy_all}
  end
  
  private 
  
  def add_author_to_authors
    user_briefs.create(:user => author, :author => true)
  end
  
  # Oh intrepid developer! If you have arrived here here are some comments to help 
  # Added by shapeshed, a developer wearing red underpants picking this application slowly apart
  # To date I have lost three years of my life getting to this point. 
  # 
  # Once a brief is created this method clones the brief items from the template_brief_questions
  # into brief_items. This solves the issue of what happens if template items are changed
  # after a brief is created as we are effectively operating on a clone.  
  #
  # Dig with a big shovel through BriefItem and you'll find it makes use of 
  # acts_as_versioned (http://github.com/technoweenie/acts_as_versioned). Note that if you 
  # make database changes to template_questions these will need to be reflected in both
  # brief_items and brief_item_versions.
  #
  # Carry on..
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body, :is_heading => question.is_heading, :optional => question.optional, :help_message => question.help_message)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
end
