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
  
  context "brief templates" do
    setup do
      @brief_section = BriefSection.make
      @brief_template = BriefTemplate.make
    end
    
    should "respond_to assign_brief_template" do
      @brief_section.respond_to?(:assign_brief_template=)
    end
    
    context "add brief template to section" do
       setup do
         @brief_section.assign_brief_template = @brief_template        
       end
       
       should_change "BriefSectionBriefTemplate.count", :by => 1    
     end

  end  

end
