require 'test_helper'

class CreativeQuestionTest < ActiveSupport::TestCase
  should_belong_to :creative
  should_belong_to :brief
  
  should_have_named_scope :hot, :order => "updated_at DESC"
  should_have_named_scope :answered, :conditions=>["author_answer != ?", ""], :order => "updated_at DESC"
end
