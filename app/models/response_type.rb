class ResponseType < ActiveRecord::Base
  has_many :brief_questions
  serialize :options
  validates_presence_of :title
end
