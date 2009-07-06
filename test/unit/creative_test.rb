require 'test_helper'

class CreativeTest < ActiveSupport::TestCase
  should_have_many :creative_questions
  
  should_have_many :creative_proposals
  should_have_many :watched_briefs
  
  # pathways to the hallowed briefs
  should_have_many :responded_briefs
  should_have_many :watching_briefs
  
  should_have_instance_methods :watching, :pitching, :complete, :under_review
    
  context "briefs" do
    setup do
      @creative = Creative.make
      @draft = Brief.make
      
      @published = Brief.make(:published)
      
      assert @draft.draft?
      assert @published.published?
    end

    context "watching" do
      setup do
        assert @creative.errors.blank?
        assert @creative.watching.blank?
      end

      should "not be able to watch unpublished briefs" do
        assert !@creative.watch(@draft)
        assert !@creative.errors.blank?
        assert @creative.watching.blank?
      end

      should "be able to watch a published brief" do      
        assert @creative.watch(@published)
        assert @creative.errors.blank?
        assert @creative.watching(true).include?(@published)
      end
      
      should "not be able to watch the same brief twice" do
        assert_difference "@creative.watching.count", 1 do
          assert @creative.watch(@published)
        end
        assert_no_difference "@creative.watching.count" do
          @creative.watch(@published)
        end
      end
      
    end
    
    context "pitching" do
      setup do
        assert @creative.errors.blank?
        assert @creative.pitching.blank?
      end

      should "not be able to pitch to unpublished briefs" do
        assert !@creative.respond_to_brief(@draft)
        assert !@creative.errors.blank?
        assert @creative.pitching.blank?
      end
      
      should "create creative_proposal when pitch is created" do
        assert_difference "@creative.creative_proposals.count", 1 do
          assert @creative.respond_to_brief(@published)
        end
      end
       
      should "be able to pitch to a published brief" do      
        assert @creative.respond_to_brief(@published)
        assert @creative.errors.blank?
        assert @creative.pitching(true).include?(@published)
      end
     
      should "remove brief from watch list when building response" do
        assert @creative.watch(@published)
        assert @creative.respond_to_brief(@published)
        assert @creative.watching.blank?
      end
     
      should "not be able to pitch on the the same brief twice" do
        assert_difference "@creative.creative_proposals.count", 1 do
          assert @creative.respond_to_brief(@published)
        end
        assert_no_difference "@creative.creative_proposals.count" do
          @creative.respond_to_brief(@published)
        end
      end
           
    end
    
  end
  
end
