ActionController::Routing::Routes.draw do |map|
  
  map.resources :briefs, 
    :collection => { :browse => :get, :completed => :get }, 
    :member => { :delete => :get, :watch => :post, :collaborators => :get } do |briefs|
      briefs.resources :questions
      briefs.resources :proposals, :member => { :delete_asset => :delete }
    end
  map.resources :template_briefs, :collection => { :sort => :put } 
  map.resources :comments
  map.resources :questions
      
  map.resource :user_session, :member => { :delete => :get }
  map.resource :profile, :controller => "users"

  map.resources :users
  map.resources :user_feedbacks
  map.resources :timeline_events
  
  map.user_signup '/users/signup/:invite_code', :controller => 'users', :action => 'signup'
  
  map.with_options(:conditions => {:subdomain => AppConfig['admin_subdomain']}) do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index'
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
      admin.resources :template_briefs
      admin.resources :template_questions
    end
  end
  
  # map.plans '/signup', :controller => 'accounts', :action => 'plans'
  # map.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
  
  map.plans '/signup', :controller => 'accounts', :action => 'new'
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
  
  map.resource :account, :collection => { 
      :dashboard => :get, 
      :thanks => :get, 
      :plans => :get, 
      :billing => :any, 
      :paypal => :any, 
      :plan => :any, 
      :plan_paypal => :any, 
      :cancel => :any, 
      :cancelled => :get
    }

  map.new_account '/signup/:plan/:discount', :controller => 'accounts', :action => 'new', :plan => nil, :discount => nil
  map.dashboard 'dashboard', :controller => "briefs", :action => "index"
  map.root :controller => "pages", :action => "home"
    
  # static pages
  
  map.home '/', :controller => "pages", :action => "home"
  map.pricing '/pricing', :controller => 'pages', :action => 'pricing'
  map.tour '/tour', :controller => 'pages', :action => 'tour'
  map.terms '/terms', :controller => 'pages', :action => 'terms'
  map.privacy '/privacy', :controller => 'pages', :action => 'privacy'
  map.login '/login', :controller => 'pages', :action => 'login'
  
  map.resources :reset_password
  map.resources :assets
end
