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
        
        asker.watch(b) if !asker.watching?(b)
      
      }
    end
  
  end
  
end