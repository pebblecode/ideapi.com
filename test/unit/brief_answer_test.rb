require 'test_helper'

class BriefAnswerTest < ActiveSupport::TestCase

  #fixtures :users

  context "BriefQuestions" do
    
    setup do
      @brief = Brief.make
      @question = BriefQuestion.make
      @answer = BriefAnswer.make(:brief_question => @question, :brief => @brief)
    end

    should "provide api for looking up questions for answer" do
      assert(BriefAnswer.respond_to?(:to_brief_question), "Answer should respond to - Answer.to_question")
      assert(BriefAnswer.to_brief_question(@question).include?(@answer), "Answer class should find answer object when provided BriefQuestion object")
      assert(BriefAnswer.to_brief_question(@question.id).include?(@answer), "Answer class should find answer object when provided BriefQuestion id")
    end
    
  end
  

end
