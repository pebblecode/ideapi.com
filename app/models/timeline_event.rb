class TimelineEvent < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  def created_on
    self.created_at.to_date
  end
  
  named_scope :document_history, lambda { |document| 
    { 
      :conditions => [
        "(subject_type = ? AND subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id = ?)",
        "Document", document, "Document", document
      ] 
    } 
  }
  
  named_scope :document_history_with_document_items, lambda { |document| 
    { 
      :conditions => [
        "(subject_type = ? AND subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id IN (?))",
        "Document", document, "Document", document, "DocumentItem", document.document_item_ids
      ] 
    } 
  }
  
  named_scope :approver_items_with_last_week, lambda { |*args| 
    { 
      :conditions => [
        "event_type = 'new_question' AND subject_id IN (?) AND created_at > ? AND actor_id != ?",
         args.first, 7.weeks.ago, args.second
      ]
    }
  }
        
  
end
