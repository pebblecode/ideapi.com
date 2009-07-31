require 'test_helper'

class BriefItemTest < ActiveSupport::TestCase
  should_belong_to :brief
  
  context "revisions" do
    setup do
      @brief = Brief.make
      @brief_item = @brief.brief_items.create({:title => "boom", :body => "something about something", :template_question => TemplateQuestion.make})
    end
    
    should "be valid" do
      assert_equal({}, @brief_item)
    end
    
    context "changing the body" do
      setup do
        @new_body = "this has changed"
        @brief_item.update_attribute(:body, @new_body)
        @brief_item.reload
      end
      
      should "change the body" do
        assert_equal(@new_body, @brief_item.body)
      end
      
      should "revise" do
        assert_equal({}, @brief_item.versions)
      end
      
      should "update the version number" do
        assert_equal(2, @brief_item.version)
      end
      
      should_change "BriefItem::Version.count", :by => 1

    end
  end
  
  
end
