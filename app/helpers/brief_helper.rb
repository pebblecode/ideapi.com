module BriefHelper
  
  def show_brief_path(brief)
    brief.published? ? brief_path(brief) : edit_brief_path(brief)
  end
  
  def comments_tab(item)
    # The tab name should also be changed in ajaxify.js, since it's updated via ajax.
    
    if item.timeline_events.length > 0
      "(#{item.total_activity_count}) Discussion / History"
    else
      "Discussion / History"
    end
  end
end