Sham.define do
  title { Faker::Lorem.sentence }
  name  { Faker::Name.name }
  body  { Faker::Lorem.paragraph }
  input_type { %w(text_field text_area select) } 
  
  email { Faker::Internet.email }
  screename { Faker::Internet.user_name.gsub(/\./, '_') }
  password { Faker::Lorem.words.join }
end

TemplateDocument.blueprint do
  title
end

TemplateSection.blueprint do
  title
end

TemplateQuestion.blueprint do
  body
  help_message { Sham.body }
  optional { (rand(2) % 2 == 0) ? true : false }
  template_section { TemplateSection.make }
end

Account.blueprint do
  name
  domain { Faker::Internet.domain_word }
  plan { SubscriptionPlan.make(:free) }
end

SubscriptionPlan.blueprint do
  name
  amount 0
  user_limit nil
end

SubscriptionPlan.blueprint(:free) do
  name "Free"
  amount 0
  user_limit nil
end

SubscriptionPlan.blueprint(:basic) do
  name "Basic"
  amount 10
  user_limit nil
end

SubscriptionPlan.blueprint(:premium) do
  name "Premium"
  amount 30
  user_limit nil
end

Document.blueprint do
  title
  template_document { TemplateDocument.make(:default => true) }
  most_important_message { Sham.body }
  author { User.make }
end

Document.blueprint(:published) do
  state "published"
end

DocumentItem.blueprint do
  title
  body
end

User.blueprint do
  screename
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  email
  password
  password_confirmation { password }
  invite_count { 0 }
  state { "active" }
end

User.blueprint(:stubbed) do
  screename { nil }
  password { nil }
  password_confirmation { password }
  state { "pending" }
end

Question.blueprint do
  body
end

Question.blueprint(:answered) do
  author_answer { Sham.body }
end

# Invitation.blueprint do
#   user
#   recipient_email { Sham.email }
# end

Proposal.blueprint do
  title
  long_description { Sham.body }
end

Proposal.blueprint(:published) do
  published_at { 1.day.ago }
end
