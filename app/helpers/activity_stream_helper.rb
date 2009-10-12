module ActivityStreamHelper
  
  def activity_snapshot(activity_hash_from_brief)
    activity_hash_from_brief.collect do |activity_type, collection| 
      activity_action(activity_type, collection) 
    end.join(", ")
  end
  
  def activity_action(activity_type, collection)     
    action_parts = []
    action_parts << pluralize(collection.count, activity_type.to_s)
    action_parts << ((collection.count > 1) ? 'need' : 'needs')
    
    case activity_type
    when :question
      action_parts << "answering"
    when :idea
      action_parts << "approving"
    end
    
    action_parts.join(" ")
  end
  
  def stream_item(event)
    "#{link_to given_name(event.actor), user_path(event.actor)} #{action_description(event)}"
  end
  
  def action_description(event)
    case event.event_type
    when "brief_created"
      "created this brief"
    when "brief_updated"
      "updated this brief"
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