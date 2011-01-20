module ProposalsHelper

  def creative_response_button(document, proposal = nil,  options = {})
    options = options.reverse_merge(button_link_options)
    creative_response_link(document, proposal, options)
  end
  
  def creative_response_link(document, proposal, options = {})
    if proposal.present?
      cr_button(*show_response(document, proposal) << options)
    else
      cr_button(*create_response(document) << options)
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
  
  def show_response(document, proposal)
    if proposal.draft?
      return 'Edit your response', edit_document_proposal_path(document, proposal)
    else
      return 'View your response', document_proposal_path(document, proposal)
    end
  end
  
  def create_response(document)
    return 'Draft response',  new_document_proposal_path(document)
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
