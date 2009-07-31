Sham.define do
  title { Faker::Lorem.sentence }
  name  { Faker::Name.name }
  body  { Faker::Lorem.paragraph }
  input_type { %w(text_field text_area select) } 
  
  email { Faker::Internet.email }
  login { Faker::Internet.user_name }
  password { Faker::Lorem.words.join }
end

TemplateBrief.blueprint do
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

Brief.blueprint do
  title
  user { User.make }
  template_brief { TemplateBrief.make }
  most_important_message { Sham.body }
end

Brief.blueprint(:published) do
  state "published"
end

BriefItem.blueprint do
  title
  body
  template_question
end

User.blueprint do
  login
  email
  password
  password_confirmation { password }
end

Question.blueprint do
  body
end

Question.blueprint(:answered) do
  author_answer { Sham.body }
end