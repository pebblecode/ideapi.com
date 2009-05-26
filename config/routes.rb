ActionController::Routing::Routes.draw do |map|
  map.resources :creative_responses
  map.resources :users
  
  map.resources :briefs do |briefs|
    briefs.resources :brief_answers
  end
  
  map.resources :brief_questions
  map.resources :brief_sections
  map.resources :brief_configs

  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  
  map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route
end
