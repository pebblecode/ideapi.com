ActionController::Routing::Routes.draw do |map|
  map.resources :creative_responses
  map.resources :users
  
  map.resources :briefs do |briefs|
    briefs.resources :answers
  end
  
  # Administration Area
  map.namespace :admin do |admin|
    admin.resources :sections
    admin.resources :questions
    admin.resources :brief_configs
  end
  
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  
  map.root :controller => "briefs", :action => "index" # optional, this just sets the root route
end
