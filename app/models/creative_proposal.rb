class CreativeProposal < ActiveRecord::Base
  belongs_to :brief
  belongs_to :creative
  
  validates_uniqueness_of :brief_id, :scope => :creative_id, :message => "Brief already has pitch associated with it"
end
