class WatchedBrief < ActiveRecord::Base
  belongs_to :brief
  belongs_to :creative

  validates_uniqueness_of :brief_id, :scope => :creative_id, :message => "Brief is already being watched"
end
