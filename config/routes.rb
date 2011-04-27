ActionController::Routing::Routes.draw do |map|
  
  map.resources :documents, 
    :collection => { :browse => :get, :completed => :get}, 
    :member => { :delete => :get, :watch => :post, :collaborators => :get, :clean => :post, :update_collaborators => :post} do |documents|
      documents.resources :questions
      documents.resources :proposals, :member => { :delete_asset => :delete }
      documents.resources :user_documents
  end
  
  map.resources :user_documents
  map.resources :template_documents, :collection => { :sort => :put } 
  map.resources :comments
  map.resources :questions
  map.resources :document_items, :collection => { :sort => :put } 
      
  map.resources :tags

  map.resource :user_session, :member => { :delete => :get }
  map.resource :profile, :controller => "users"
  

  map.resources :users
  map.resources :user_feedbacks
  map.resources :timeline_events
  
  map.user_signup '/users/signup/:invite_code', :controller => 'users', :action => 'signup'
  map.user_send_invite '/users/send_invite/:id', :controller => 'users', :action => 'send_invite'
  
  map.with_options(:conditions => {:subdomain => AppConfig['admin_subdomain']}) do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index' 
    subdom.account_owners_custom_query '/account_owners/custom_query', :controller => 'subscription_admin/account_owners', :action => 'custom_query'    
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :account_owners
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
      admin.resources :template_documents
      admin.resources :template_questions
    end   
  end
  
  # map.plans '/signup', :controller => 'accounts', :action => 'plans'
  # map.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
  
  map.plans '/signup', :controller => 'accounts', :action => 'new'
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
  
  map.resource :account, :collection => { 
      :documents => :get, 
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
  map.documents 'documents', :controller => "documents", :action => "index"
  map.root :controller => "pages", :action => "home"
    
  # static pages
  
  map.home '/', :controller => "pages", :action => "home"
  map.pricing '/pricing', :controller => 'pages', :action => 'pricing'
  map.faq '/faq', :controller => 'pages', :action => 'faq'
  map.features '/features', :controller => 'pages', :action => 'features'
  map.terms '/terms', :controller => 'pages', :action => 'terms'
  map.privacy '/privacy', :controller => 'pages', :action => 'privacy'
  map.login '/login', :controller => 'pages', :action => 'login'
  map.login_action '/login/create', :controller => 'pages', :action => 'login_action'
  map.help '/help', :controller => 'pages', :action => 'help'
  map.who '/who', :controller => 'pages', :action => 'who'
  # To reset password: *.ideapi.com/reset_password/:perishable_token/edit, where :perishable_token is in the users table
  map.resources :reset_password
  map.resources :assets
end
