module CommentsHelper
  
  def comment_adjective_for(name)
    %w(mused asked pondered inquired posed quizzed).rand << " #{name}"
  end
  
end