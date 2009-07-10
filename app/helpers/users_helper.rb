module UsersHelper
  
  def large_avatar
    avatar(:large)
  end
  
  def medium_avatar
    avatar(:medium)
  end
  
  def small_avatar
    avatar(:small)
  end
  
  def user_link(user_object)
    link_to(user_object.login, user_path(user_object))
  end
  
  def given_name(user_object)
    current_user?(user_object) ? "You" : user_object.login
  end
  
  def current_user?(user_object)
    user_object == current_user
  end
  
  private
  
  def avatar(size)
    image_tag current_user.avatar.url(size), :class => "avatar_#{size} avatar"
  end
  
end