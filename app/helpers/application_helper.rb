# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def submitter(text, options = {})
    options = { :class => "submit" }.merge(options)
    submit_tag text, options
  end
  
  def comment_adjective_for(name)
    %w(mused asked commented pondered inquired posed quizzed).rand << " #{name}"
  end
  
  def user_link(user_object)
    link_to(user_object.login, user_path(user_object))
  end
  
  def avatar(user_object, size)
    filename = user_object.avatar.url(size)
    filename = "/images/avatar/default_#{size}.png" if !File.exists?(filename)
    image_tag filename
  end
  
end
