Author.seed(:login, :email) do |s|  
  s.login = "client"   
  s.email = "client@ideapi.net"
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
template = TemplateBrief.find_by_title("Default")
creative = Creative.find_by_login("creative")

if client && creative && template
  draft_brief = Brief.create(:title => "Draft brief", :author => client, :template_brief => template)
  
  puts "\t- creating published brief"
  to_publish = Brief.create(:title => "Published brief", :author => client, :template_brief => template)
  
  # puts "\t- stubbling out the answers"
  # print "\t"
  # to_publish.brief_answers.each do |answer|
  #   print "."
  #   answer.update_attribute(:body, "Stubbed answer to #{answer.brief_question.title}")
  # end
  # 
#   
   puts "\n\t- publishing brief"
   to_publish.publish!
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
 
