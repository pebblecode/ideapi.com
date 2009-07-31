ActionController::Routing::Routes.draw do |map|  
  map.resources :briefs, :collection => { :browse => :get }, :member => { :delete => :get, :watch => :post } do |briefs|
    briefs.resources :questions
  end
  
  map.resource :user_session, :member => { :delete => :get }
  map.resource :profile, :controller => "users"
  map.resources :users
  
  # Administration Area
  map.namespace :admin do |admin|
  end
  
  map.resource :home, :controller => "home"
  map.root :controller => "home", :action => "show" # optional, this just sets the root route
end
