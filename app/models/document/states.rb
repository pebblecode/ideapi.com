class Document < ActiveRecord::Base

  # State machine
  include AlterEgo
  include Ideapi::Schizo

  state :draft, :default => true do
    handle :publish! do
      stored_transition_to(:published)
    end
    handle :complete! do nil end
    handle :review! do nil end
    handle :reactivate! do nil end
    handle :archive! do nil end
  end

  state :published do
    handle :complete! do
      stored_transition_to(:complete)
    end
  
    handle :review! do
      stored_transition_to(:under_review)
    end
    
    handle :publish! do nil end
    handle :reactivate! do nil end
    handle :archive! do nil end
  end

  state :under_review do
    handle :complete! do
      stored_transition_to(:complete)
    end
    handle :review! do nil end
    handle :reactivate! do nil end
    handle :archive! do nil end
  end

  state :complete do
    handle :reactivate! do
      stored_transition_to(:published)
    end
    
    handle :archive! do
      stored_transition_to(:archived)
    end
    handle :complete! do nil end
    handle :review! do nil end
  end

  state :archived
  
  become_schizophrenic
  
  # ensure default state is defined in lib
  before_save :ensure_default_state
    
  ACTIVE_STATES = %w(draft published)
  
  def active?
    Document::ACTIVE_STATES.include?(state.to_s)
  end

  named_scope :active, :conditions => [ 'state IN (?)', Document::ACTIVE_STATES ]

end