require 'test_helper'

class UserTest < Test::Unit::TestCase
  should_have_attached_file :avatar
  should_have_many :briefs
  should_have_many :questions
  
  should_have_many :proposals
  should_have_many :watched_briefs
  
  # pathways to the hallowed briefs
  should_have_many :responded_briefs
  should_have_many :watching_briefs
  
  should_have_instance_methods :watching, :pitching, :complete, :under_review
  
  context "briefs" do
    setup do
      User.delete_all
      
      @user = User.make
      @draft = Brief.make

      @published = Brief.make(:published)

      assert @draft.draft?
      assert @published.published?
    end

    context "watching" do
      setup do
        assert @user.errors.blank?
        assert @user.watching.blank?
      end

      should "not be able to watch unpublished briefs" do
        assert !@user.watch(@draft)
        assert !@user.errors.blank?
        assert @user.watching.blank?
      end

      should "be able to watch a published brief" do      
        assert @user.watch(@published)
        assert @user.errors.blank?
        assert @user.watching(true).include?(@published)
      end
  
      context "once watching a brief" do
        
        setup do
          @user.watch(@published)
        end
        
        should "be watching the brief" do
          assert @user.watching(true).include?(@published)
        end
        
        should_change "WatchedBrief.count", :by => 1
        
        context "attempting to pitch on a brief twice" do
          setup do
            @user.watch(@published)
          end
          
          should_not_change "WatchedBrief.count"
          
        end
        
      end

    end

    context "pitching" do
      setup do
        assert @user.errors.blank?
        assert @user.pitching.blank?
      end

      should "not be able to pitch to unpublished briefs" do
        assert !@user.respond_to_brief(@draft)
        assert !@user.errors.blank?
        assert @user.pitching.blank?
      end

      context "pitching on a brief" do
        setup do
          @user.respond_to_brief(@published)
        end
        
        should "be pitching on the brief" do
          assert @user.pitching(true).include?(@published)
        end
        
        should_change "Proposal.count", :by => 1
      end

      should "be able to pitch to a published brief" do      
        assert @user.respond_to_brief(@published)
        assert @user.errors.blank?
        assert @user.pitching(true).include?(@published)
      end

      should "remove brief from watch list when building response" do
        assert @user.watch(@published)
        assert @user.respond_to_brief(@published)
        assert @user.watching.blank?
      end
      
      context "once pitching on a brief" do
        
        setup do
          @user.respond_to_brief(@published)
        end
        
        should "be pitching on the brief" do
          assert @user.pitching(true).include?(@published)
        end
        
        should_change "Proposal.count", :by => 1
        
        context "attempting to pitch on a brief twice" do
          setup do
            @user.respond_to_brief(@published)
          end
          
          should_not_change "Proposal.count"
          
        end
        
      end

    end

  end

end