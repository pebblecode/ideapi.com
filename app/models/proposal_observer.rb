class ProposalObserver < ActiveRecord::Observer

  def after_create(proposal)
    proposal.user.proposal_created(proposal)
  end

end
