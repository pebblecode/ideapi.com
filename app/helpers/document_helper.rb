module DocumentHelper
  
  def show_document_path(document)
    document.published? ? document_path(document) : edit_document_path(document)
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