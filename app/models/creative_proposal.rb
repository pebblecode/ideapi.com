class CreativeProposal < ActiveRecord::Base
  belongs_to :brief
  belongs_to :creative
end
