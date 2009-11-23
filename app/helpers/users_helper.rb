module UsersHelper
  
  def large_avatar(user = nil)
    avatar(user, :large, [100,100])
  end
  
  def medium_avatar(user = nil)
    avatar(user, :medium, [48,48])
  end
  
  def small_avatar(user = nil)
    avatar(user, :small, [32,32])
  end
  
  def user_link(user_object)
    if user_object.pending?
      given_name(user_object)
    else
      link_to(given_name(user_object), user_path(user_object))
    end
  end
  
  def given_name(user_object)
    if user_object.present?
      current_user?(user_object) ? "You" : name_or_login(user_object).titleize
    end
  end
  
  def name_or_login(user_object)
    user_object.full_name.present? ? user_object.full_name : user_object.login
  end
  
  def current_user?(user_object)
    user_object == current_user
  end
  
  def salutation
    (%w(alright hello welcome hey hi).rand << " " << current_user.login).titleize
  end
  
  def brief_item_updated_for_user?(brief_item)
    user_brief = brief_item.brief.user_briefs.for_user(current_user)
    if user_brief.present? && user_brief.last_viewed_at.present? && brief_item.updated_at.present?
      user_brief.last_viewed_at < brief_item.updated_at
    else
      false
    end
  end
  
  private
  
  def avatar(user, size, geo)
    user = current_user if user.nil?
    image_tag user.avatar.url(size), :class => "avatar_#{size} avatar", :width => geo[0], :height => geo[1]
  end
  
end