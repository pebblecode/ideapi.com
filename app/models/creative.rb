class Creative < User
  has_many :creative_proposals
  has_many :creative_questions
  
  acts_as_voter
end
