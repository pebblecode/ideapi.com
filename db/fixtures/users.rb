Author.seed(:login, :email) do |s|  
  s.login = "jason"   
  s.email = "jase@jaseandtonic.com"
  s.password = "testing"
  s.password_confirmation = "testing"   
end

Creative.seed(:login, :email) do |s|
  s.login = "creative"   
  s.email = "creative@jaseandtonic.com"
  s.password = "testing"
  s.password_confirmation = "testing"
end

jason = Author.find_by_login("jason")
template = BriefTemplate.find_by_title("Default")

if jason && template 
  draft_brief = Brief.create(:title => "Draft brief", :author => jason, :brief_template => template)
  
  puts "\t- creating published brief"
  to_publish = Brief.create(:title => "Published brief", :author => jason, :brief_template => template)
  
  puts "\t- stubbling out the answers"
  print "\t"
  to_publish.brief_answers.each do |answer|
    print "."
    answer.update_attribute(:body, "Stubbed answer to #{answer.brief_question.title}")
  end
  
  puts "\n\t- publishing brief"
  to_publish.publish!
  
end