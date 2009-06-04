require 'test_helper'

class BriefWorkflowTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  context "Creating a brief" do
    
    setup do
      @author = Author.make(:password => "testing")
      @brief = Brief.plan
      login_as(@author)
    end

    should "be able to create a brief" do
      visit briefs_path
      assert_equal briefs_path, path
      click_link 'new brief'
      assert_response :success
      assert_equal new_brief_path, path
      assert_contain 'Create new brief'
      
      fill_in "brief[title]", :with => @brief[:title]
      click_button
      assert_response :success
      assert_contain @brief[:title].titlecase
    end

  end
  
  context "Access to briefs" do
    
    setup do
      @author = Author.make(:password => "testing")
      assert @brief = brief_for(Author.make(:password => "testing"))
      
      login_as(@author)      
      visit briefs_path
      assert_equal '/briefs', path
    end
    
    should "see a list of other briefs even when author has none" do
      assert @author.briefs.empty?
      assert_contain @brief.title
    end
    
    should "be able to view a brief" do
      click_link 'show'
      assert_response :success
      assert_equal brief_path(@brief), path
    end
    
  end
  
  context "not logged in" do
    
    setup do
      # make sure we have at least a brief
      @brief = Brief.make
    end
    
    should "be able to view a list of briefs" do
      visit briefs_path
      assert_response :success
      assert_equal briefs_path, path
      assert_contain @brief.title
    end
    
    context "viewing a brief" do
      setup do
        visit brief_path(@brief)
      end
  
      should "be able to view a brief" do
        assert_response :success
        assert_equal brief_path(@brief), path
        assert_contain @brief.title.titlecase
      end
  
      should "not be able to comment on a brief" do
        assert_have_no_selector("form", :action => brief_comments_path(@brief))
      end
      
    end
    
  end

end
