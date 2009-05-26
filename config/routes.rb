ActionController::Routing::Routes.draw do |map|
  map.resources :creative_responses
  map.resources :users
  map.resources :briefs
  map.resources :brief_answers
  map.resources :brief_questions
  map.resources :brief_sections
  map.resources :brief_configs

  map.resource :user_session
  map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route
end
