require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  should_belong_to :user
  should_belong_to :brief
  should_belong_to :brief_item
  
  should_have_named_scope :recent, :order => "updated_at DESC"
  should_have_named_scope :answered, :conditions=>["author_answer != ?", ""], :order => "updated_at ASC"
  should_have_named_scope :unanswered, :conditions=>["author_answer IS NULL"], :order => "created_at ASC"
  
  should_have_instance_methods :answered?
  
end
