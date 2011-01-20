class Site < ActiveRecord::Base
  has_many :documents
  has_many :template_documents
end
