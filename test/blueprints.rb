Sham.define do
  title { Faker::Lorem.sentence }
  name  { Faker::Name.name }
  body  { Faker::Lorem.paragraph }
  input_type { %w(text_field text_area select) } 
  
  email { Faker::Internet.email }
  login { Faker::Internet.user_name }
  password { Faker::Lorem.words.join }
  brief_config { BriefConfig.current }
end

Answer.blueprint do
  body
  question { Question.make }
  brief { Brief.make }
end

BriefConfig.blueprint do
  title
end

Brief.blueprint do
  title
  user { User.make }
  brief_config
end

Question.blueprint do
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

Section.blueprint do
  title
  strapline { Sham.body }
end

User.blueprint do
  login
  email
  password
  password_confirmation { password }
end