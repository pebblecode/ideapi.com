module BriefHelper
  
  def show_brief_path(brief)
    brief.published? ? brief_path(brief) : edit_brief_path(brief)
  end
end