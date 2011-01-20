Given /^there are free, basic and premium plans$/ do
  @plans = returning({}) do |plans|
    %w(free basic premium).each do |plan_name|
      plans[plan_name.to_sym] = SubscriptionPlan.make(plan_name.to_sym)
    end
  end
end

Given /^a default ideapi template document exists$/ do
  should_have_template_document # see test_helper.rb
end

Given /^I am logged in as an account admin$/ do
    @user_limit = 5
  
    @user = User.make(:password => "testing")
    @account = Account.make(:user => @user, :plan => SubscriptionPlan.make(:basic, :user_limit => @user_limit))
    Capybara.default_host = @account.full_domain
    visit "http://" + @account.full_domain + ":9887"
    fill_in 'Email', :with => @user.email
    fill_in 'Password', :with => "testing"
    click_button 'Login'
end

Given /^I have documents called (.+)$/ do |documents|
  documents.split(', ').each do |document|
    @published = Document.make(:published, :author => @user, :account => @account, :title => document)
  end
end

Given /^I have a document called "([^"]*)" tagged with "([^"]*)"$/ do |document, tags|
  @published = Document.make(:published, :author => @user, :account => @account, :title => document)
  @account.tag(@published, :with => tags, :on => :tags)
end

Given /^I have a user called "([^"]*)" with the email "([^"]*)"$/ do |user, email|
  bits = user.split(' ')
  @user = User.make(:password => "testing", :email => email, :first_name => bits[0], :last_name => bits[1])
end
