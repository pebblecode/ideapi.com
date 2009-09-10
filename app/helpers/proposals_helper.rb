module ProposalsHelper

  def creative_response_button(brief, proposal = nil)
    if proposal.present?
      #cr_button(show_response(brief, proposal))
    else
      cr_button(*create_response(brief))
    end
  end
  
  private
  
  def show_response(brief, proposal)
    return 'View your response', brief_proposal_path(brief, proposal)
  end
  
  def create_response(brief)
    return 'Draft response',  new_brief_proposal_path(brief)
  end
  
  def link_options
    {
      :class => "awesome blue large", 
      :style => "text-transform: uppercase" 
    }
  end
  
  def cr_button(text, link, options = {})
    options = options.reverse_merge(link_options)
    link_to text, link, options
  end
  

end
