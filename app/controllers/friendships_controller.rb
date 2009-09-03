class FriendshipsController < ApplicationController
  
  layout 'login'
  before_filter :require_user
  
  def current_object
    @current_object ||= Friendship.find_by_id_and_friend_id(params[:id], current_user)
  end
  
  make_resourceful do
    actions :show, :update, :delete    
    belongs_to :user
    
    before :update do
      if current_object.requested?
        current_user.accept_friendship_with(
          current_object.friendshipped_by_me
        ) 
      end
    end
    
    response_for :update do |format|
      format.html {
        flash[:notice] = "You are now contacts with #{current_object.friendshipped_by_me.login}"
        redirect_to user_path(current_user)
      }
    end
    
  end

end
