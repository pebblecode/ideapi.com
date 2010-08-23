module BriefHelper
  
  def show_brief_path(brief)
    brief.published? ? brief_path(brief) : edit_brief_path(brief)
  end
  
  def comments_tab(item)
    if item.timeline_events.count > 0
      "Comment (#{item.total_activity_count})"
    else
      "Comment"
    end
  end
end