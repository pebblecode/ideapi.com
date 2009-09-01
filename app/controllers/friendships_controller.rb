class FriendshipsController < ApplicationController
  
  make_resourceful do
    actions :show, :update, :delete    
    belongs_to :user
  end
  
  # parent_object is standard make_resourceful accessor
  # overwrite with our current logged in user
  alias :parent_object :current_user

end
