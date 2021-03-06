class Proposal < ActiveRecord::Base
  #before_update :update_status
  belongs_to :document
  belongs_to :user
  
  delegate :approver, :to => :document
  delegate :full_name, :to => :user, :prefix => true, :allow_nil => true

  validates_presence_of :title, :long_description
  
  has_many :assets, :as => :attachable
  
  accepts_nested_attributes_for :assets, 
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['data'].blank? }
    
  
  acts_as_commentable
  
  def users
    return [self.user] if self.draft?
    [self.user, self.approver, self.document.authors].flatten.uniq
  end

  def belongs_to?(a_user)
    user == a_user
  end
  
  include Ideapi::Schizo
  
  state :draft, :default => true do
    handle :publish! do
      self.published_at = Time.now
      stored_transition_to(:published)
    end
    handle :approve! do nil end
    handle :drop! do nil end
    handle :needs_work! do nil end
  end
    
  state :published do
    handle :needs_work! do
      stored_transition_to(:needs_work)
    end
    
    handle :approve! do
      stored_transition_to(:approved)
    end
    
    handle :drop! do
      stored_transition_to(:dropped)
    end
    
    handle :publish! do
      nil
    end
  end
  
  state :needs_work do
    handle :approve! do
      stored_transition_to(:approved)
    end
    
    handle :drop! do
      stored_transition_to(:dropped)
    end
    handle :needs_work! do 
      nil
    end
    handle :publish! do
      nil
    end
  end
  
  state :approved do
    handle :needs_work! do
      stored_transition_to(:needs_work)
    end
    
    handle :drop! do
      stored_transition_to(:dropped)
    end
    handle :approve! do
      nil
    end
    handle :publish! do
      nil
    end
  end
  
  state :dropped do
    handle :needs_work! do
      stored_transition_to(:needs_work)
    end
    
    handle :approve! do
      stored_transition_to(:approved)
    end
    handle :drop! do
      nil
    end
    handle :publish! do
      nil
    end
  end
  
  become_schizophrenic

  before_save :ensure_default_state
  after_update :notify_approvers_of_idea_creation
  after_update :notify_if_state_changed
  after_save   :update_document
  
  named_scope :active, :conditions => ["state <> 'draft'"]
  
  named_scope :for_user, lambda { |user|
        { :conditions => { :user_id => user.id } }
      }
  
  fires :new_proposal, :on => :create,
                       :actor => :user,
                       :secondary_subject  => 'document',
                       :log_level => 1
                       
  fires :proposal_marked, :on => :update,
                          :actor => 'approver',
                          :secondary_subject  => 'document',
                          :if => lambda { |proposal| (proposal.previous_state != proposal.state) && (Proposal.approval_states.include?(proposal.state)) },
                          :log_level => 1
  
  class << self
    def approval_states
      states.reject{|state_name,state_object| state_name.to_s =~ /draft|published/ }
    end

    def approval_state_names
      approval_states.collect{|state_name,state_object| state_name.to_s }
    end
  end

  
  private
  
  def notify_if_state_changed
    if state_changed? && self.class.approval_state_names.include?(self.state.to_s)
      # As this is now being processed by Resque we need to pass
      # the id as it gets processed by a worker
      begin
        NotificationMailer.deliver_user_idea_reviewed_on_document(self.id) unless self.user.pending? or self.draft?
      rescue Errno::ECONNREFUSED
        nil #maybe we should handle this properly
      end
    end
  end
  
  def notify_approvers_of_idea_creation
    if state_changed? and (self.state_change | ['draft', :published] == self.state_change)
      # As this is now being processed by Resque we need to pass
      # the id as it gets processed by a worker
      begin
        NotificationMailer.deliver_to_approver_idea_submitted_on_document(self.approver.id, self.id) unless self.approver.pending? or self.draft?
      rescue Errno::ECONNREFUSED
        nil #maybe we should handle this properly
      end
    end
  end
  
  def update_status
    self.state = "draft"
  end
  
  def update_document
    self.document.updated_at = Time.now
    self.document.save false
  end
end
