Sham.define do
  title { Faker::Lorem.sentence }
  name  { Faker::Name.name }
  body  { Faker::Lorem.paragraph }
  input_type { %w(text_field text_area select) } 
  
  email { Faker::Internet.email }
  login { Faker::Internet.user_name }
  password { Faker::Lorem.words.join }
end

BriefAnswer.blueprint do
  body
  brief_question { BriefQuestion.make }
  brief { Brief.make }
end

BriefConfig.blueprint do
  title
end

BriefTemplate.blueprint do
  brief_config { BriefConfig.make } 
end

Brief.blueprint do
  title
  user { User.make }
  brief_template { BriefTemplate.make }
end

BriefQuestion.blueprint do
  title
  help_text { Sham.body }
end

CreativeResponse.blueprint do
  short_description { Sham.body }
  long_description { Sham.body }
  brief { Brief.make }
  user { User.make }
end

ResponseType.blueprint do
  title 
  input_type
end

BriefSection.blueprint do
  title
  strapline { Sham.body }
end

User.blueprint do
  login
  email
  password
  password_confirmation { password }
end