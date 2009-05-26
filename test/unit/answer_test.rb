require 'test_helper'

class AnswerTest < Test::Unit::TestCase

  context "Questions" do
    setup do
      @brief = Brief.make
      @question = Question.make
      @answer = Answer.make(:question => @question, :brief => @brief)
    end

    should "provide api for looking up questions for answer" do
      assert(Answer.respond_to?(:to_question), "Answer should respond to - Answer.to_question")
      assert(Answer.to_question(@question).includes?(@answer))
      assert(Answer.to_question(@question.id).includes?(@answer))
    end
  end
  

end
