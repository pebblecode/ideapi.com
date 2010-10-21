class SubscriptionAdmin::AccountOwnersController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  
  before_filter :load_templates, :only => [:edit, :update]
  before_filter :build_template, :only => [:edit]
  
  
  def index
    @account_owners = ViewAccountOwner.all
  end
end
