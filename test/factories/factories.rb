Factory.define :account do |a|
  a.name "The A-Team"
  a.full_domain "theateam.ideapi.local"
end

Factory.define :account_user do |a|
  a.association :user, :factory => :user
  a.association :account, :factory => :account
  a.admin true  
end

Factory.define :subscription_plan do |s|
  s.name "Free"
  s.amount 0
  s.user_limit 
end

Factory.define :subscription do |s|
  s.state         
  s.association :subscription_plan, :factory => :subscription_plan
  s.association :account, :factory => :account
end

Factory.define :template_document do |t|
  t.title 'Default'
  t.default '1'
end

Factory.define :user do |u|
  u.screename "ba_barracus"
  u.email "ba@gmail.com"
  u.first_name "Barry"
  u.last_name "Barracus"
  u.job_title "Hired muscle"
  u.password "password"
  u.password_confirmation "password"
  u.telephone "0203 123 4567"
  u.state "active"
end





