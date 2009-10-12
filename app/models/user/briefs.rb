class User < ActiveRecord::Base

  named_scope :authors, :conditions => 'user_briefs.author = true'

  def watch(brief)
    return false if !brief
    
    if brief.published?
      watched_briefs.create(:brief => brief) unless self.owns?(brief)
    else
      errors.add_to_base("You cannot watch a brief which isn't currently published")
      false
    end
  end
  
  def toggle_watch!(brief)
    watching?(brief) ? watching.delete(brief) : watch(brief)
  end
  
  def watching?(brief)
    watching.include?(brief)
  end
  
  def pitching?(brief)
    responded_briefs.include?(brief)
  end
  
  def proposal_for(brief)
    proposals.find_by_brief_id(brief)
  end
  
  def respond_to_brief(brief)
    if brief.published?
      transaction do
        watching.delete(brief)
        proposals.create(:brief => brief, :title => "Your response to #{brief.title}", :long_description => "Enter your response here")
      end      
    else
      errors.add_to_base("You cannot respond to a brief which isn't currently published")
      false
    end
  end
    
  alias :watching :watching_briefs
  alias :pitching :responded_briefs
  
  delegate :under_review, :to => :responded_briefs
  delegate :complete, :to => :responded_briefs
  
  def author?
    published.present?
  end
  
  def owns?(thing)
    assoc = thing.class.to_s.tableize
    respond_to?(assoc) && send(assoc).include?(thing)
  end
  
  def briefs_grouped_by_state
    returning(BriefCollection.new) do |collection|
      hash = briefs.all.group_by(&:state)
      hash[:watching] = watching if !watching.empty?
      hash[:pitching] = pitching if !pitching.empty?
      
      collection.populate(hash)
    end
  end
  
  def last_viewed_brief(brief)
    if view = brief_user_views.find_by_brief_id(brief)
      view.last_viewed_at
    else
     1.year.ago
    end
  end

end