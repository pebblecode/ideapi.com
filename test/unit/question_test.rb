require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  
  context "Questions and sections" do
    setup do
      @question = Question.make
      @section = Section.make
    end

    should "be able to assign a section to question via assignment" do
      assert @question.respond_to?(:assign_section)
      assert @question.sections.blank?
      @question.assign_section @section
      assert !@question.sections.blank?
    end
    
    should "be able to make section assignment via assign_section=" do
      assert @question.respond_to?(:assign_section=)
      assert @question.sections.blank?
      @question.assign_section=@section
      assert !@question.sections.blank?
    end
    
  end
  

end
