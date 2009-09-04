%w(jason alex seb toby fergus).each do |peep|
  User.seed(:login, :email) do |s|
    s.login = peep
    s.email = "#{peep}@ideapi.com"
    s.password = "password"
    s.password_confirmation = "password"
    s.invite_count = 9999
  end
end

if RAILS_ENV != "production"
  require 'test/test_helper'
  
  include BriefWorkflowHelper
  
  users = User.all
  
  users.each do |user|
    
    3.times do
      brief = Brief.make(:published, { :user => user, :template_brief => TemplateBrief.find_by_title('Default') })
      
      brief.brief_items.each { |b_i| b_i.update_attribute(:body, Sham.body) }
      
    end
    
    user.briefs.reload.each do |b|
      10.times { 
        
        asker = User.all(:conditions => ["id <> ?", user.id]).rand
        b.brief_items.reload.rand.questions.make(:user => asker) 
        
        user.become_friends_with(asker) unless user.is_friends_with?(asker)
        
        asker.watch(b) if !asker.watching?(b)
      
      }
    end
  
  end
  
end

if RAILS_ENV == "production"
  
  #Tim Purble, tpurble Sanjay Mahindra, sanjay June Withers, JuneW Michael Martin xSpeaker Adrian Mole, amole
  
  users = [
    %w(Tim Purble tpurble),
    %w(Sanjay Mahindra sanjay),
    %w(June Withers JuneW),
    %w(Michael Martin xSpeaker),
    %w(Adrian Mole amole)
  ]
  
  users.each do |peep|
    User.seed(:login, :email) do |s|
      s.first_name = peep[0]
      s.last_name = peep[1]
      s.login = peep[2]
      s.email = "#{peep[2]}@example.com"
      s.password = "password"
      s.password_confirmation = "password"
      #s.invite_count = 9999
    end    
  end
  
  # if alex = User.find_by_login("alex")
  #   
  #   if brief = alex.briefs.build(:template_brief => TemplateBrief.find_by_title("Default"))
  #     
  #     brief.title = "ideapi.com logo and branding"
  #     brief.most_important_message = "ideapi needs a logo and branding to launch it and make it a success"
  #     
  #     puts "Created sample ideapi brief" if brief.save
  #     
  #   end
  #   
  # end
end