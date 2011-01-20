class AccountTemplateDocument < ActiveRecord::Base
  belongs_to :account
  belongs_to :template_document, :dependent => :destroy
  validates_presence_of :account_id, :template_document_id
  
end
