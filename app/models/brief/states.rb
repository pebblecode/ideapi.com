class Brief < ActiveRecord::Base

  # State machine
  include AlterEgo
  include Ideapi::Schizo

  state :draft, :default => true do
    handle :publish! do
      ensure_approver_set
      stored_transition_to(:published)
    end  
  end

  state :published do
    handle :complete! do
      stored_transition_to(:complete)
    end
  
    handle :review! do
      stored_transition_to(:under_review)
    end
  end

  state :under_review do
    handle :complete! do
      stored_transition_to(:complete)
    end
  end

  state :complete do
    handle :archive! do
      stored_transition_to(:archived)
    end  
  end

  state :archived
  
  become_schizophrenic
  
  # ensure default state is defined in lib
  before_save :ensure_default_state

end