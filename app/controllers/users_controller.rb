class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
    
  def current_object
    @current_object ||= (params[:id].blank?) ? current_user : super
  end
    
  make_resourceful do
    actions :new, :create, :show, :edit, :update
  end
 
end
