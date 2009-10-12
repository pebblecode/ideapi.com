class TimelineEvent < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  
  def created_on
    self.created_at.to_date
  end
  
  named_scope :brief_history, lambda { |brief| 
    { 
      :conditions => [
        "(subject_type = ? AND subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id = ?)",
        "Brief", brief, "Brief", brief
      ] 
    } 
  }
  
  named_scope :brief_history_with_brief_items, lambda { |brief| 
    { 
      :conditions => [
        "(subject_type = ? AND subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id = ?) OR (secondary_subject_type = ? AND secondary_subject_id IN (?))",
        "Brief", brief, "Brief", brief, "BriefItem", brief.brief_item_ids
      ] 
    } 
  }
  
  
  
  
end
