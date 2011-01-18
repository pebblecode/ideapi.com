module ProposalsHelper

  def creative_response_button(brief, proposal = nil,  options = {})
    options = options.reverse_merge(button_link_options)
    creative_response_link(brief, proposal, options)
  end
  
  def creative_response_link(brief, proposal, options = {})
    if proposal.present?
      cr_button(*show_response(brief, proposal) << options)
    else
      cr_button(*create_response(brief) << options)
    end
  end
  
  def proposal_state_heading(state)
    case state
    when :published
      "Awaiting approval"
    when :needs_work
      "Needs work"
    when :approved
      "Approved"
    when :draft
      "Not yet submitted"
    when :dropped
      "Dropped"
    end
  end
  
  private
  
  def show_response(brief, proposal)
    if proposal.draft?
      return 'Edit your response', edit_brief_proposal_path(brief, proposal)
    else
      return 'View your response', brief_proposal_path(brief, proposal)
    end
  end
  
  def create_response(brief)
    return 'Draft response',  new_brief_proposal_path(brief)
  end
  
  def button_link_options
    {
      :class => "awesome blue large", 
      :style => "text-transform: uppercase" 
    }
  end
  
  def cr_button(text, link, options = {})
    link_to text, link, options
  end
  

end
