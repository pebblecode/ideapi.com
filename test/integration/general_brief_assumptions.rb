require 'test_helper'

class GeneralBriefAssumptions < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "creative" do
    setup do
      @creative = Author.make(:password => "testing")
      login_as(@creative)

      @draft = Brief.make
      @published = Brief.make(:published)
    end

    should "be able to view briefs" do
      visit briefs_path
      assert_response :success
      assert_equal(briefs_path, path)
    end
    
    should "be able to view a brief which is published" do
      visit brief_path(@published)
      assert_response :success
      assert_equal(brief_path(@published), path)
    end
        
    should "not be able to view unpublished briefs" do
      visit brief_path(@draft)
      assert_response :success
      assert_equal(briefs_path, path)
    end
    
    should "not be able to create briefs" do
      
    end
    
    should "not be able to edit briefs"
    should "not be able to delete briefs"
  end
  
end