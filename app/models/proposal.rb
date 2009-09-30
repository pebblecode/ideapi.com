class Proposal < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  delegate :approver, :to => :brief
  
  validates_uniqueness_of :brief_id, 
    :scope => :user_id, 
    :message => "You are already pitching for this brief"

  validates_presence_of :title, :long_description
  
  has_many :assets, :as => :attachable
  
  accepts_nested_attributes_for :assets, :allow_destroy => true
  
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
  
  named_scope :active, :conditions => ["state <> 'draft'"]
  
  fires :new_proposal, :on => :create,
                       :actor => :user,
                       :secondary_subject  => 'brief'
                       
  fires :proposal_marked, :on => :update,
                          :actor => 'approver',
                          :secondary_subject  => 'brief',
                          :if => lambda { |proposal| (proposal.previous_state != proposal.state) && (Proposal.approval_states.include?(proposal.state)) }
  
  class << self
    def approval_states
      states.reject{|state_name,state_object| state_name.to_s =~ /draft|published/ }
    end

    def approval_state_names
      approval_states.collect{|state_name,state_object| state_name.to_s }
    end
  end
  
end
