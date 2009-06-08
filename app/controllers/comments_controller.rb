class CommentsController < ApplicationController
  before_filter :require_user
  
  make_resourceful do  
    belongs_to :creative_question
    actions :create, :destroy
    
    before :create do
      current_object.user = current_user
    end
    
    response_for(:create, :create_fails, :destroy, :destroy_fails) do |format|
      format.html { redirect_to brief_path(parent_object) }
    end
    
  end
  
end
