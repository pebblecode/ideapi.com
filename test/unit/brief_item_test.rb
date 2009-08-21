require 'test_helper'

class BriefItemTest < ActiveSupport::TestCase
  should_belong_to :brief
  
  context "revisions" do
    setup do
      @brief = Brief.make(:published)
      
      @init_body = "something about something"
      
      @brief_item = @brief.brief_items.create({:title => "boom", :body => @init_body, :template_question => TemplateQuestion.make})
    end
    
    should "be valid" do
      assert_equal(@init_body, @brief_item.body)
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
      
      should "update the version number" do
        assert_equal(2, @brief_item.version)
      end
      
      should_change "BriefItem::Version.count", :by => 1

      context "parsing carriage returns" do
        setup do
          @formatted_body = "this is a body\n\nwith some space in it,\n\nand also\nsome links in it great"
          @parsed_body = "this is a body<br /><br />with some space in it,<br /><br />and also<br />some links in it great"
          @brief_item.update_attribute(:body, @formatted_body)
          @brief_item.reload
        end

        should "turn linebreaks into <br> tags" do
          assert_equal(@parsed_body, @brief_item.body_parsed)
        end
      end
      
      context "parsing links" do
        setup do
          @formatted_body = "come on visit http://jasoncale.com or something maybe http://ideapi.net instead"
          @parsed_body = "come on visit <a href='http://jasoncale.com' title='visit: http://jasoncale.com'>http://jasoncale.com</a> or something maybe <a href='http://ideapi.net' title='visit: http://ideapi.net'>http://ideapi.net</a> instead"
          
          @brief_item.update_attribute(:body, @formatted_body)
          @brief_item.reload
        end

        should "turn linebreaks into <br> tags" do
          assert_equal(@parsed_body, @brief_item.body_parsed)
        end
      end
      

    end
  end
  
  
end
