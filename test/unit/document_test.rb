require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  include DocumentWorkflowHelper

  context "A document" do
    setup do
      should_have_template_document
      account, author = user_with_account
      @document = Document.make(:published, :author => author, :account => account)
      populate_document(@document, 1)
    end
    
    should "have document items" do 
      assert_equal 1, @document.document_items.count
    end
    
    context "when created" do
      should "have created" do
        assert_equal("document_created", @document.timeline_events.first.event_type)
      end
      
      should "and updated actions in its history" do
        assert_equal("document_updated", @document.timeline_events.last.event_type)
      end
      
    end
    
    context "updating a document item" do
      setup do
        @document_item = @document.document_items.first
        @document_item.body = "update the body"
        @document_item.save
      end
      
      should "create an entry in the document history" do
        # 4 because: document_created, document_updated, document_item_changed, document_updated
        assert_equal(4, @document.timeline_events(:include_document_items => true).size)
      end
      
      should "create an updated_document entry in the history" do
        # Document item updates now "touch" their respective documents, so the last will always be a document_updated
        assert_equal("document_updated", @document.timeline_events(:include_document_items => true).last.event_type)
      end
      
      should "have 1 document item history from the update" do
        assert_equal(1, @document_item.timeline_events.size)
      end
      
      
      context "updating a document item a second time" do
        setup do
          @document_item.body = "Second update!"
          @document_item.save
        end
        
        should "create a document_item_changed history event" do
          assert_equal("document_item_changed", @document_item.timeline_events.last.event_type)
        end
      end
      
    end
  end
end