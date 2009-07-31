module UsersHelper
  
  def large_avatar(user = nil)
    avatar(user, :large)
  end
  
  def medium_avatar(user = nil)
    avatar(user, :medium)
  end
  
  def small_avatar(user = nil)
    avatar(user, :small)
  end
  
  def user_link(user_object)
    link_to(user_object.login, user_path(user_object))
  end
  
  def given_name(user_object)
    current_user?(user_object) ? "You" : user_object.login.titleize
  end
  
  def current_user?(user_object)
    user_object == current_user
  end
  
  def salutation
    (%w(alright hello welcome hey hi).rand << " " << current_user.login).titleize
  end
  
  def brief_item_updated_for_user?(brief_item)
    if !user_last_viewed_brief.blank? && user_last_viewed_brief.last_viewed_at.is_a?(Time)
      (brief_item.updated_at > user_last_viewed_brief.last_viewed_at)
    end
  end
  
  private
  
  def avatar(user, size)
    user = current_user if user.nil?
    image_tag user.avatar.url(size), :class => "avatar_#{size} avatar"
  end
  
end