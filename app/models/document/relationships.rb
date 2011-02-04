require 'set'

class Document < ActiveRecord::Base

  # The acts-as-taggable handles tags on the model
  # See http://github.com/mbleigh/acts-as-taggable-on
  acts_as_taggable

  # acts_as_taggable isn't quite as flexible as we need
  # it to be so this virutal attribute allows some post 
  # processing on form submissions. See the after_create 
  # and after_update filters in the controller. 
  attr_accessor :tag_field


  # RELATIONSHIPS
  
  # TEMPLATE DOCUMENT 
  # this builds the template sections
  # that the document author is presented 
  # with when creating the document
  
  belongs_to :account
  belongs_to :template_document
  after_create :generate_document_items_from_template!


  # DOCUMENT ITEMS
  has_many :document_items, :order => 'position ASC, created_at ASC, id ASC'
  
  accepts_nested_attributes_for :document_items, 
    :allow_destroy => true, 
    :reject_if => :all_blank
    
  has_many :document_items_answered, 
    :class_name => 'DocumentItem', 
    :conditions => ['document_items.body <> ""'], 
    :order => :position
    
  # RELATIONSHIP WITH USERS
  has_many :user_documents do
    def for_user(user)
      first :conditions => ['user_id = ?', user]
    end
  end
  
  accepts_nested_attributes_for :user_documents, 
    :allow_destroy => true
  
  before_update :check_for_author_deletion, :check_for_last_author_removal
  
  def check_for_author_deletion
    author_guard = self.user_documents.select {|ub| ub.marked_for_destruction? && ub.user == self.author }
      
    if author_guard.present?
      errors.add(:user_documents, "You cannot remove the document author from a document")
      return false
    end
  end
  
  def check_for_last_author_removal
    if (self.user_documents.authored.count == 1) && self.user_documents.authored.any?(&:marked_for_destruction?)
      errors.add(:user_documents, "You cannot remove the only author from a document")
      return false
    end
  end
  
  has_many :users, :through => :user_documents
  delegate :authors, :to => :users
  
  # convience methods for finding users to add to a document
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
    { :conditions => ["documents.account_id = ?", account.id] }
  }

  # Tests are whining at this named scope switching to simple ordering for now
  named_scope :ordered, lambda { |order| {:order => order || "updated_at DESC"} }
  # named_scope :ordered, :order => "updated_at DESC"
  def clean_document!
    self.questions.destroy_all
    self.comments.destroy_all
    self.timeline_events().each{|event| event.destroy}
    self.document_items.each{|item| item.timeline_events.destroy_all}
  end
  
  private 
  
  def add_author_to_authors
    user_documents.create(:user => author, :author => true)
  end
  
  # Oh intrepid developer! If you have arrived here here are some comments to help 
  # Added by shapeshed, a developer wearing red underpants picking this application slowly apart
  # To date I have lost three years of my life getting to this point. 
  # 
  # Once a document is created this method clones the document items from the template_document_questions
  # into document_items. This solves the issue of what happens if template items are changed
  # after a document is created as we are effectively operating on a clone.  
  #
  # Dig with a big shovel through DocumentItem and you'll find it makes use of 
  # acts_as_versioned (http://github.com/technoweenie/acts_as_versioned). Note that if you 
  # make database changes to template_questions these will need to be reflected in both
  # document_items and document_item_versions.
  #
  # Carry on..
  def generate_document_items_from_template!
    raise 'TemplateDocumentMissing' if template_document.blank?
  
    template_document.template_questions.each do |question|
      self.document_items.create(:title => question.body, :is_heading => question.is_heading, :optional => question.optional, :body => question.default_content)
    end
    
    return (document_items.count == template_document.template_questions.count)
  end
  
end
