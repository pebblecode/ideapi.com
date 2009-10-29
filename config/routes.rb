ActionController::Routing::Routes.draw do |map|

  map.resources :invitations, 
    :collection => { 
      :request_invitations => :get, 
      :request_invitation_for_email => :post }, 
    :member => { 
      :resend => :get, 
      :cancel => :get 
    }
  
  map.resources :briefs, 
    :collection => { :browse => :get }, 
    :member => { :delete => :get, :watch => :post, :collaborators => :get } do |briefs|
      briefs.resources :questions
      briefs.resources :proposals, :member => { :delete_asset => :delete }
    end
  
  map.resources :comments
    
  map.resources :friendships
  
  map.resource :user_session, :member => { :delete => :get }
  map.resource :profile, :controller => "users"

  map.resources :users
  map.resources :user_feedbacks
  
  map.with_options(:conditions => {:subdomain => AppConfig['admin_subdomain']}) do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index'
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
    end
  end
  
  map.plans '/signup', :controller => 'accounts', :action => 'plans'
  map.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
  map.resource :account, :collection => { :dashboard => :get, :thanks => :get, :plans => :get, :billing => :any, :paypal => :any, :plan => :any, :plan_paypal => :any, :cancel => :any, :canceled => :get }
  map.new_account '/signup/:plan/:discount', :controller => 'accounts', :action => 'new', :plan => nil, :discount => nil
  
  map.connect 'dashboard', :controller => "briefs", :action => "index"
  map.resource :home, :controller => "home"
  map.root :controller => "home", :action => "show"
  
end
