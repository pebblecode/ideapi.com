class ResponseType < ActiveRecord::Base
  has_many :questions
  serialize :options
  validates_presence_of :title
end
