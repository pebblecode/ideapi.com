require 'test_helper'

class BriefTest < ActiveSupport::TestCase

  include BriefWorkflowHelper

  context "A brief" do
    setup do
      should_have_template_brief
      account, author = user_with_account
      @brief = Brief.make(:published, :author => author, :account => account)
      populate_brief(@brief, 1)
    end
    
    should "have brief items" do
      assert_equal 1, @brief.brief_items.count
    end
    
    context "when created" do
      should "have created action in its history" do
        assert_equal("brief_created", @brief.timeline_events.first.event_type)
      end
    end
    
    context "updating a brief item" do
      setup do
        @brief_item = @brief.brief_items.first
        @brief_item.body = "update the body"
        @brief_item.save
      end
      
      should "create an entry in the brief history" do
        assert_equal(3, @brief.timeline_events(:include_brief_items => true).size)
      end
      
      should "create an updated_brief entry in the history" do
        assert_equal("brief_item_changed", @brief.timeline_events(:include_brief_items => true).last.event_type)
      end
      
      should "fire a brief_item_changed on the updated brief item" do
        assert_equal("brief_item_changed", @brief_item.timeline_events(:include_brief_items => true).last.event_type)
      end
      
    end
    
  end
  

end