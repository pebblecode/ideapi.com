require 'test_helper'

class BriefSectionTest < ActiveSupport::TestCase
  should_have_many :brief_templates, :through => :brief_section_brief_templates
  should_have_many :brief_questions, :through => :brief_section_brief_questions

  context "ordering" do
    setup do
      @section_1 = BriefSection.make(:position => 1)
      @section_2 = BriefSection.make(:position => 2)
      @section_3 = BriefSection.make(:position => 3)
    end
    
    should "have ordering methods" do
      assert BriefSection.respond_to?(:order!)
    end
    
    
    should "order successfully" do
      BriefSection.order!([@section_3.id, @section_1.id, @section_2.id])
      
      assert_equal(@section_3, BriefSection.ordered.first)
      assert_equal(@section_2, BriefSection.ordered.last)
    end
  end
  

end
