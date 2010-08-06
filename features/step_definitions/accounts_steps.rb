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

