class SubscriptionAdmin::AccountOwnersController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  
  before_filter :reject_unauthorized_hosts
  
  def index
    sort_desc = (params[:desc] == "true" ) ? " DESC" : ""
    @sort_by_description = ""
    if (params[:sortby] == "last_login_at")
      @account_owners = ViewAccountOwner.find(:all)
      @users = User.find(:all, :order => "last_login_at #{sort_desc}")
    else # Otherwise don't sort
      @account_owners = ViewAccountOwner.find(:all)
      @users = User.find(:all)        
    end
    
  end
end
