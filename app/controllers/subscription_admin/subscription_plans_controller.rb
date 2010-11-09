class SubscriptionAdmin::SubscriptionPlansController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  before_filter :reject_unauthorized_hosts
  
  protected
  
    def load_object
      @obj = @subscription_plan = SubscriptionPlan.find_by_name(params[:id])
    end
end
