class Creative < User
  has_many :creative_questions
  has_many :creative_proposals
  has_many :watched_briefs
  
  # pathways to the hallowed briefs
  has_many :responded_briefs, :through => :creative_proposals, :source => :brief
  has_many :watching_briefs, :through => :watched_briefs, :source => :brief
  
  def watch(brief)
    if brief.published?
      watching_briefs << brief
    else
      errors.add_to_base("You cannot watch a brief which isn't currently published")
      false
    end
  end
  
  def briefs
    watching_briefs + responded_briefs
  end
  
  alias :watching :watching_briefs
  alias :pitching :responded_briefs
  
  delegate :under_review, :to => :responded_briefs
  delegate :complete, :to => :responded_briefs
  
end
