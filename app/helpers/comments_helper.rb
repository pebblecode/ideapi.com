module CommentsHelper
  
  def comment_adjective_for(name, options = {})
    options.reverse_merge!(:position => :after)
    adj = %w(mused asked pondered inquired posed quizzed).random_element
    if options[:position] == :before
      "#{name} " << adj
    else
      adj << " #{name}"
    end     
  end
  
end