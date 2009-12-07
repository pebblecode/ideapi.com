plans = [
  { 'name' => 'Basic', 'amount' => 10, 'user_limit' => 5 },
  { 'name' => 'Premium', 'amount' => 30, 'user_limit' => nil }
].collect do |plan|
  SubscriptionPlan.seed(:name) do |s|
    s.name = plan['name']
    s.amount = plan['amount']
    s.user_limit = plan['user_limit']
  end
end