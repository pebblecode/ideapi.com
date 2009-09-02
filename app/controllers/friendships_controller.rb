class FriendshipsController < ApplicationController
  
  layout 'login'
  before_filter :require_user
  
  before_filter :requested_by
  
  make_resourceful do
    actions :show, :update, :delete    
    belongs_to :user
    
    before :update do
      if current_object.requested?
        current_user.be_friends_with!(requested_by) 
      end
    end
    
    response_for :update do |format|
      format.html {
        flash[:notice] = "You are now contacts with #{requested_by.login}"
        redirect_to user_path(current_user)
      }
    end
    
  end
  
  # parent_object is standard make_resourceful accessor
  # overwrite with our current logged in user
  alias :parent_object :current_user

  private
  
  def requested_by
    @requested_by ||= User.find(current_object.user_id)
  end

end
