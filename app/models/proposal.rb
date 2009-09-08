class Proposal < ActiveRecord::Base
  belongs_to :brief
  belongs_to :user
  
  validates_uniqueness_of :brief_id, 
    :scope => :user_id, 
    :message => "You are already pitching for this brief"
  
end
