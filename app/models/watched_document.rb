class WatchedDocument < ActiveRecord::Base
  belongs_to :document
  belongs_to :user

  validates_uniqueness_of :document_id, :scope => :user_id, :message => "Document is already being watched"
end
