class Creative < User
  has_many :creative_questions
  has_many :watched_briefs

  has_many :creative_responses

  def briefs
    watched_briefs # + creative_responses
  end

end
