class WatchedBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user

  validates_uniqueness_of :brief_id, :scope => :user_id, :message => "Document is already being watched"
end
