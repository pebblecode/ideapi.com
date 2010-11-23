Given /^I am logged in with permission to create briefs$/ do
  session.reset! 
  Factory(:template_brief)
  @account = Factory(:account, :user => Factory(:user), :plan => Factory(:subscription_plan))
  visit new_user_session_url(:host => @account.full_domain)
  fill_in "Email", :with =>  @account.user.email
  fill_in "Password", :with => @account.user.password
  click('Login')
end

Then /^I should see a link called Templates$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a page where I can manage templates$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I have a template called "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^I visit the templates page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^when I follow "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should see a page where I can add a new template$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I click edit$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I have a template called "The best template evarrr!'$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I visit the template page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be able to reorder sections:w$/ do
  pending # express the regexp above with the code you wish you had
end
