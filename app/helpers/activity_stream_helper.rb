module ActivityStreamHelper
  
  def stream_item(event)
    #<TimelineEvent id: 1, event_type: "brief_created", subject_type: "Brief", actor_type: "User", secondary_subject_type: nil, subject_id: 1, actor_id: 1, secondary_subject_id: nil, created_at: "2009-10-01 11:25:47", updated_at: "2009-10-01 11:25:47">
    
    item = "
      #{link_to given_name(event.actor), user_path(event.actor)} #{action_description(event)}
    "
  end
  
  def action_description(event)
    case event.event_type
    when "brief_created"
      "created this brief"
    when "new_question"
      "asked a #{link_to 'question', brief_questions_path(event.secondary_subject)} on the brief"
    when "question_answered"
      "answered #{given_name(event.subject.user)} #{link_to 'question', brief_questions_path(event.secondary_subject)}"
    when "new_proposal"
      "submitted an idea"
    when "proposal_marked"
      "idea was marked as #{event.subject.state} by #{given_name(event.subject.approver)}"
    when "new_comment"
      if event.secondary_subject.is_a?(Proposal)
        "commented on #{given_name(event.subject.user)} idea"
      else
        "commented on the brief"
      end
    else
      event.event_type.humanize
    end
  end
  
end