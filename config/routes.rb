ActionController::Routing::Routes.draw do |map|
  map.resources :invitations, :collection => { :request_invitations => :get }, :member => { :resend => :get, :cancel => :get }
  
  map.resources :briefs, :collection => { :browse => :get }, :member => { :delete => :get, :watch => :post, :invite => :post } do |briefs|
    briefs.resources :questions
  end
  
  map.resource :user_session, :member => { :delete => :get }
  map.resource :profile, :controller => "users"
  map.resources :users
  
  map.resources :user_feedbacks
  
  
  # Administration Area
  map.namespace :admin do |admin|
  end
  
  map.connect 'dashboard', :controller => "briefs", :action => "index"
  map.resource :home, :controller => "home"
  map.root :controller => "home", :action => "show"
end
