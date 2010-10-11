Given /^there are free, basic and premium plans$/ do
  @plans = returning({}) do |plans|
    %w(free basic premium).each do |plan_name|
      plans[plan_name.to_sym] = SubscriptionPlan.make(plan_name.to_sym)
    end
  end
end

Given /^a default ideapi template brief exists$/ do
  should_have_template_brief # see test_helper.rb
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

Given /^I have briefs called (.+)$/ do |briefs|
  briefs.split(', ').each do |brief|
    @published = Brief.make(:published, :author => @user, :account => @account, :title => brief)
  end
end

Given /^I have a brief called "([^"]*)" tagged with "([^"]*)"$/ do |brief, tags|
  @published = Brief.make(:published, :author => @user, :account => @account, :title => brief)
  @account.tag(@published, :with => tags, :on => :tags)
end

Given /^I have a user called "([^"]*)" with the email "([^"]*)"$/ do |user, email|
  bits = user.split(' ')
  @user = User.make(:password => "testing", :email => email, :first_name => bits[0], :last_name => bits[1])
end


