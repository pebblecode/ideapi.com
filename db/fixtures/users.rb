# %w(jason alex seb toby fergus).each do |peep|
#   User.seed(:screename, :email) do |s|
#     s.screename = peep
#     s.email = "#{peep}@ideapi.com"
#     s.password = "password"
#     s.password_confirmation = "password"
#     s.invite_count = 9999
#   end
# end
# 
# if RAILS_ENV != "production"
#   require 'test/test_helper'
#   
#   include DocumentWorkflowHelper
#   
#   users = User.all
#   
#   users.each do |user|
#     
#     3.times do
#       document = Document.make({:author => user, :template_document => TemplateDocument.find_by_title('Default') })
#       document.document_items.each { |b_i| b_i.update_attribute(:body, Sham.body) }
#       document.publish!
#     end
#     
#     user.documents.reload.each do |b|
#       10.times { 
#         asker = User.all(:conditions => ["id <> ?", user.id]).rand
#         
#         unless b.users.include?(asker)
#           b.users << asker
#         end
#         
#         b.document_items.reload.rand.questions.make(:user => asker) 
#       }
#     end
#     
#     users.each do |other|
#       unless other.eql?(user)
#         user.become_friends_with(other)
#       end
#     end
#   
#   end
#   
# end
# 
# if RAILS_ENV == "production"
#   
#   #Tim Purble, tpurble Sanjay Mahindra, sanjay June Withers, JuneW Michael Martin xSpeaker Adrian Mole, amole
#   
#   users = [
#     %w(Tim Purble tpurble),
#     %w(Sanjay Mahindra sanjay),
#     %w(June Withers JuneW),
#     %w(Michael Martin xSpeaker),
#     %w(Adrian Mole amole)
#   ]
#   
#   users.each do |peep|
#     User.seed(:login, :email) do |s|
#       s.first_name = peep[0]
#       s.last_name = peep[1]
#       s.screename = peep[2]
#       s.email = "#{peep[2]}@example.com"
#       s.password = "password"
#       s.password_confirmation = "password"
#       #s.invite_count = 9999
#     end    
#   end
#   
#   # if alex = User.find_by_screename("alex")
#   #   
#   #   if document = alex.documents.build(:template_document => TemplateDocument.find_by_title("Default"))
#   #     
#   #     document.title = "ideapi.com logo and branding"
#   #     document.most_important_message = "ideapi needs a logo and branding to launch it and make it a success"
#   #     
#   #     puts "Created sample ideapi document" if document.save
#   #     
#   #   end
#   #   
#   # end
# end