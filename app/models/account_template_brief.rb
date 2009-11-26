class AccountTemplateBrief < ActiveRecord::Base
  belongs_to :account
  belongs_to :template_brief
  
  validates_presence_of :account_id, :template_brief_id
  
end
