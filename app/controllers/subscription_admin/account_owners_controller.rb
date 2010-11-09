class SubscriptionAdmin::AccountOwnersController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  
  before_filter :reject_unauthorized_hosts
  
  def index
    @account_owners = ViewAccountOwner.all
  end
end
