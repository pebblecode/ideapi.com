class CreativeQuestion < ActiveRecord::Base
  belongs_to :creative
  belongs_to :brief
end
