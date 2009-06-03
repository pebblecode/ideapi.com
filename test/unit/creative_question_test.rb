require 'test_helper'

class CreativeQuestionTest < ActiveSupport::TestCase

  context "love and hate" do
    setup do
      @question = CreativeQuestion.make  
    end

    should "have love / hate actions" do
      assert(@question.respond_to?(:love!), "question should respond to love!")
      assert(@question.respond_to?(:hate!), "Question should respond to hate!")
    end
    
    should "increment love count on love!" do
      assert_difference "@question.love_count", 1 do
        @question.love!
      end
    end
    
    should "increment love count on hate!" do
      assert_difference "@question.hate_count", 1 do
        @question.hate!
      end
    end
        
  end

end
