require 'Faker'

Author.seed(:login, :email) do |s|  
  s.login = "client"   
  s.email = "client@ideapi.net"
  s.password = "password"
  s.password_confirmation = "password"   
end

Author.seed(:login, :email) do |s|  
  s.login = "random"   
  s.email = "random@ideapi.net"
  s.password = "password"
  s.password_confirmation = "password"   
end

Creative.seed(:login, :email) do |s|
  s.login = "creative"   
  s.email = "creative@ideapi.net"
  s.password = "password"
  s.password_confirmation = "password"
end

client = Author.find_by_login("client")
random = Author.find_by_login("random")
template = TemplateBrief.find_by_title("Default")
creative = Creative.find_by_login("creative")

if client && creative && template
  draft_brief = Brief.create(:title => "Design for a dog biscuit", :author => client, :template_brief => template, :most_important_message => "We are looking for a revolutionary dog biscuit here - we are looking for the iphone of the dog biscuit world.")
  
  puts "\t- creating published brief"
  to_publish = Brief.create(:title => "Campaign for womens underwear", :author => client, :template_brief => template, :most_important_message => "We want designs for womens underwear that can be made out of renewable sources.")
  
  # puts "\t- stubbling out the answers"
  # print "\t"
  to_publish.brief_items.each do |answer|
    print "."
    answer.update_attribute(:body, Faker::Lorem.paragraph)
  end
  # 
#   
   puts "\n\t- publishing brief"
   to_publish.publish!
   
   puts "\n\t- creating random brief"
   random_brief = random.briefs.create(:title => "Campaign for womens underwear", :template_brief => template, :most_important_message => Faker::Lorem.paragraph)
   
   random_brief.brief_items.each do |answer|
     print "."
     answer.update_attribute(:body, Faker::Lorem.paragraph)
   end
   
   random_brief.publish!
   
#   
#   # to_publish.brief_answers.first.creative_questions.create(
#   #    :creative => creative, 
#   #    :body => "Why do we scream at each other?", 
#   #    :answer => "This is what it sounds like when do doves cry"
#   #  )
#   #  

else
  puts "Client, creative or template can't be found"
end
 
