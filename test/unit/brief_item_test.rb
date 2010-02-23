require 'test_helper'

class BriefItemTest < ActiveSupport::TestCase

  include BriefWorkflowHelper

  context "Given a brief with a single brief item with an empty body" do
    setup do
      should_have_template_brief
      account, author = user_with_account
      @brief = Brief.make(:published, :author => author, :account => account)
      @brief.brief_items.make(:body => "")
    end
    
    should "create a initial version" do
      assert_equal 1, @brief.brief_items.first.versions.count
    end
    
    should "have zero timeline events" do
      assert @brief.brief_items.first.timeline_events.blank?
    end
    
    context "filling in the body from previous nil value" do
      
      setup do
        brief_item = @brief.brief_items.first
        brief_item.body = "super tight"
        brief_item.save
      end
      
      should "have the body 'super tight'" do
        assert_equal("super tight", @brief.brief_items.first.body)
      end
      
      should "create a new version" do
        assert_equal 2, @brief.brief_items.first.versions.count
      end
      
      should "have zero timeline events" do
        assert @brief.brief_items.first.timeline_events.blank?
      end
      
      context "and then changing the body from a value, to another value" do
        setup do
          brief_item = @brief.brief_items.first
          brief_item.body = "horribly wrong"
          brief_item.save
        end

        should "have the body 'horribly wrong'" do
          assert_equal("horribly wrong", @brief.brief_items.first.body)
        end
        
        should "create a new version" do
          assert_equal 3, @brief.brief_items.first.versions.count
        end

        should "have a new timeline event" do
          assert_equal 1, @brief.brief_items.first.timeline_events.count
        end
        
        should "contain the previous body change in the latest timeline event" do
          assert_equal "super tight", @brief.brief_items.first.timeline_events.first.subject.body
        end
        
        context "attaching a question to the brief item" do
          setup do
            @brief.brief_items.first.questions.make(:body => "respect", :user => User.make)
          end

          should "have increase question count" do
            assert_equal(1, @brief.brief_items.first.questions.count)
          end
          
          should "increase brief item timeline event count by 1" do
            assert_equal 2, @brief.brief_items.first.timeline_events.count
          end
          
          should "appear as the latest item in the brief item history" do
            assert_equal "respect", @brief.brief_items.first.timeline_events.last.subject.body
          end
        end
        
        
      end
    
    end

  end
end