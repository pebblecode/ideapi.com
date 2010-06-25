class Proposal < ActiveRecord::Base
  before_update :update_status
  belongs_to :brief
  belongs_to :user
  
  delegate :approver, :to => :brief

  validates_presence_of :title, :long_description
  
  has_many :assets, :as => :attachable
  
  accepts_nested_attributes_for :assets, 
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['data'].blank? }
    
  
  acts_as_commentable
  
  include Ideapi::Schizo
  
  state :draft, :default => true do
    handle :publish! do
      self.published_at = Time.now
      stored_transition_to(:published)
    end  
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
  end
  
  state :needs_work do
    handle :approve! do
      stored_transition_to(:approved)
    end
    
    handle :drop! do
      stored_transition_to(:dropped)
    end
  end
  
  state :approved do
    handle :needs_work! do
      stored_transition_to(:needs_work)
    end
    
    handle :drop! do
      stored_transition_to(:dropped)
    end
  end
  
  state :dropped do
    handle :needs_work! do
      stored_transition_to(:needs_work)
    end
    
    handle :approve! do
      stored_transition_to(:approved)
    end
  end
  
  become_schizophrenic

  before_save :ensure_default_state
  after_create :notify_approvers_of_idea_creation
  after_update :notify_if_state_changed
  
  named_scope :active, :conditions => ["state <> 'draft'"]
  
  named_scope :for_user, lambda { |user|
        { :conditions => { :user_id => user.id } }
      }
  
  fires :new_proposal, :on => :create,
                       :actor => :user,
                       :secondary_subject  => 'brief',
                       :log_level => 1
                       
  fires :proposal_marked, :on => :update,
                          :actor => 'approver',
                          :secondary_subject  => 'brief',
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
      NotificationMailer.deliver_user_idea_reviewed_on_brief(self) 
    end
  end
  
  def notify_approvers_of_idea_creation
    NotificationMailer.deliver_to_approver_idea_submitted_on_brief(self.approver, self)
  end
  
  def update_status
    #self.state = "draft"
  end
end
