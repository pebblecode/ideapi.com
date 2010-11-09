class SubscriptionAdmin::SubscriptionDiscountsController < ApplicationController
  include ModelControllerMethods
  include AdminControllerMethods
  before_filter :reject_unauthorized_hosts
end
