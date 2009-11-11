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
    if event.present? && event.actor.present?
      action_description(event).gsub!(/ACTOR_NAME/, link_to(given_name(event.actor), user_path(event.actor)))
    end
  end
  
  def action_description(event)
    case event.event_type
    when "brief_created"
      "ACTOR_NAME created this brief"      
    when "brief_item_changed"
      "Updated by ACTOR_NAME: #{event.subject.body}"
    when "new_question"
      "ACTOR_NAME asked a #{link_to 'question', link_to_brief_item_on_brief(event.secondary_subject)} on the brief"
    when "question_answered"
      "ACTOR_NAME answered #{given_name(event.subject.user)} #{link_to 'question', link_to_brief_item_on_brief(event.secondary_subject)}"
    when "new_proposal"
      "ACTOR_NAME submitted an idea"
    when "proposal_marked"
      "ACTOR_NAME idea was marked as #{event.subject.state} by #{given_name(event.subject.approver)}"
    when "new_comment"
      if event.secondary_subject.is_a?(Proposal)
        "ACTOR_NAME commented on #{given_name(event.subject.user)} idea"
      else
        "ACTOR_NAME commented on the brief"
      end
    else
      "CXOKS"
      #event.event_type.humanize
    end
  end
  
  def link_to_brief_item_on_brief(brief_item)
    brief_path(brief_item.brief, :anchor => dom_id(brief_item))
  end
  
end