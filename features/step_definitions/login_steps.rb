Given /^I have a valid account for "([^"]*)"(?: with the subdomain "([^"]*)")?$/ do |email, domain|
  domain ||= 'testing'
  @user = User.make(:email => email, :password => 'foobar', :password_confirmation => 'foobar', :screename => 'dsmith')
  @account = Account.make(:user => @user, :domain => domain, :plan => SubscriptionPlan.make(:basic, :user_limit => 5))
end

