require 'set'

class Brief < ActiveRecord::Base

  # RELATIONSHIPS
  
  # TEMPLATE BRIEF 
  # this builds the template sections
  # that the brief author is presented 
  # with when creating the brief
  
  belongs_to :account
  belongs_to :template_brief
  after_create :generate_brief_items_from_template!

  # BRIEF ITEMS
  has_many :brief_items, :order => :position
  
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

  private 
  
  def add_author_to_authors
    user_briefs.create(:user => author, :author => true)
  end
  
  def generate_brief_items_from_template!
    raise 'TemplateBriefMissing' if template_brief.blank?
  
    template_brief.template_questions.each do |question|
      self.brief_items.create(:title => question.body, :template_question => question)
    end
    
    return (brief_items.count == template_brief.template_questions.count)
  end
  
end