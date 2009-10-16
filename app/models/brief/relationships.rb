class Brief < ActiveRecord::Base

  # RELATIONSHIPS
  
  # TEMPLATE BRIEF 
  # this builds the template sections
  # that the brief author is presented 
  # with when creating the brief
  
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
  
  has_many :users, :through => :user_briefs
  delegate :authors, :to => :users
  
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

  private 
  
  def ensure_approver_set
    self.approver_id = self.author if self.approver_id.blank?
  end
  
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