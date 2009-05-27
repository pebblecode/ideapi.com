require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  #fixtures :users

  context "Questions" do
    
    setup do
      @brief = Brief.make
      @question = Question.make
      @answer = Answer.make(:question => @question, :brief => @brief)
    end

    should "provide api for looking up questions for answer" do
      assert(Answer.respond_to?(:to_question), "Answer should respond to - Answer.to_question")
      assert(Answer.to_question(@question).include?(@answer), "Answer class should find answer object when provided Question object")
      assert(Answer.to_question(@question.id).include?(@answer), "Answer class should find answer object when provided Question id")
    end
    
  end
  

end
