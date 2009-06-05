ActionController::Routing::Routes.draw do |map|
  
  map.resources :creative_proposals
  map.resources :creative_questions
  
  map.resources :briefs do |briefs|
    briefs.resources :creative_questions, :as => 'questions'
  end
  
  # Administration Area
  map.namespace :admin do |admin|
    admin.resources :brief_templates
    admin.resources :brief_sections
    admin.resources :brief_questions
    admin.resources :brief_configs
  end
  
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
  
  map.root :controller => "briefs", :action => "index" # optional, this just sets the root route
end
