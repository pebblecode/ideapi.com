ActionController::Routing::Routes.draw do |map|  
  map.resources :briefs, :shallow => true, :member => { :publish => :put, :delete => :get }
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  
  # Administration Area
  map.namespace :admin do |admin|
  end
  
  map.resource :home, :controller => "home"
  map.root :controller => "home", :action => "show" # optional, this just sets the root route
end
