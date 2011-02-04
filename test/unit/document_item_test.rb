require 'test_helper'

class DocumentItemTest < ActiveSupport::TestCase

  include DocumentWorkflowHelper

  context "Given a document with a single document item with an empty body" do
    setup do
      should_have_template_document
      account, author = user_with_account
      @document = Document.make(:published, :author => author, :account => account)
      @document.document_items.make(:body => "")
    end
    
    should "create a initial version" do
      assert_equal 1, @document.document_items.first.versions.count
    end
    
    should "have zero timeline events" do
      assert @document.document_items.first.timeline_events.blank?
    end
    
    context "filling in the body from previous nil value" do
      
      setup do
        document_item = @document.document_items.first
        document_item.body = "super tight"
        document_item.save
      end
      
      should "have the body 'super tight'" do
        assert_equal("super tight", @document.document_items.first.body)
      end
      
      should "create a new version" do
        assert_equal 2, @document.document_items.first.versions.count
      end
      
      should "have zero timeline events" do
        assert @document.document_items.first.timeline_events.blank?
      end
      
      context "and then changing the body from a value, to another value" do
        setup do
          document_item = @document.document_items.first
          document_item.body = "horribly wrong"
          document_item.save
        end

        should "have the body 'horribly wrong'" do
          assert_equal("horribly wrong", @document.document_items.first.body)
        end
        
        should "create a new version" do
          assert_equal 3, @document.document_items.first.versions.count
        end

        should "have a new timeline event" do
          assert_equal 1, @document.document_items.first.timeline_events.count
        end
        
        should "contain the previous body change in the latest timeline event" do
          assert_equal "super tight", @document.document_items.first.timeline_events.first.subject.body
        end
        
        context "attaching a question to the document item" do
          setup do
            @document.document_items.first.questions.make(:body => "respect", :user => User.make)
          end

          should "have increase question count" do
            assert_equal(1, @document.document_items.first.questions.count)
          end
          
          should "increase document item timeline event count by 1" do
            assert_equal 2, @document.document_items.first.timeline_events.count
          end
          
          should "appear as the latest item in the document item history" do
            assert_equal "respect", @document.document_items.first.timeline_events.last.subject.body
          end
        end
        
        
      end
    
    end

  end
end