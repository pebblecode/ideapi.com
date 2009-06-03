require 'test_helper'

class BriefBriefQuestionTest < ActiveSupport::TestCase
  
  context "BriefQuestions and brief_sections" do
    setup do
      @question = BriefQuestion.make
      @section = BriefSection.make
    end

    should "be able to assign a section to question via assignment" do
      assert @question.respond_to?(:assign_brief_section)
      assert @question.brief_sections.blank?
      @question.assign_brief_section @section
      assert !@question.brief_sections.blank?
    end
    
    should "be able to make section assignment via assign_brief_section=" do
      assert @question.respond_to?(:assign_brief_section=)
      assert @question.brief_sections.blank?
      @question.assign_brief_section=@section
      assert !@question.brief_sections.blank?
    end
    
  end
  

end
