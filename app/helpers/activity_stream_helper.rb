module ActivityStreamHelper
  
  def activity_snapshot(activity_hash_from_document)
    activity_hash_from_document.collect do |activity_type, collection| 
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
    description = action_description(event) 
    if event.try(:actor).present? && description.match(/ACTOR_NAME/)
      description.gsub!(/ACTOR_NAME/, link_to(given_name(event.actor), user_path(event.actor)))
    end
    description
  end
  
  def action_description(event)
    case event.event_type
    when "document_created"
      "ACTOR_NAME created this document"
    when "document_item_changed"
      "Updated by ACTOR_NAME: #{event.subject.try(:body)}"
    when "new_question"
      "ACTOR_NAME asked a #{link_to 'question', link_to_document_item_on_document(event.secondary_subject)} on the document"
    when "question_answered"
      "ACTOR_NAME answered #{given_name(event.subject.user)} #{link_to 'question', link_to_document_item_on_document(event.secondary_subject)}"
    when "new_proposal"
      "ACTOR_NAME submitted an idea"
    when "proposal_marked"
      "ACTOR_NAME idea was marked as #{event.subject.state} by #{given_name(event.subject.approver)}"
    when "new_comment"
      if event.secondary_subject.is_a?(Proposal)
        "ACTOR_NAME commented on #{given_name(event.subject.user)} idea"
      else
        "ACTOR_NAME commented on the document"
      end
    else
      event.event_type.humanize
    end
  end
  
  def link_to_document_item_on_document(document_item)
    document_path(document_item.document, :anchor => dom_id(document_item))
  end
  
end