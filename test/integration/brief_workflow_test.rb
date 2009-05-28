require 'test_helper'

module BriefWorkflowHelper
  
  def login_as(user)
    visit new_user_session_path  
    assert_response :success  
    fill_in "login", :with => user.login
    fill_in "password", :with => "testing"
    click_button
    assert_equal '/', path
  end

  def brief_for(user)
    return Brief.make(:user => user)
  end

end

class BriefWorkflowTest < ActionController::IntegrationTest
  include BriefWorkflowHelper
  
  fixtures :users

  context "Creating a brief" do
    
    setup do
      @user = users(:jason)
      @brief = Brief.plan
      login_as(@user)
    end

    should "be able to create a brief" do
      assert_equal '/', path
      click_link 'new brief'
      assert_response :success
      assert_equal new_brief_path, path
      fill_in "brief[title]", :with => @brief[:title]
      click_button
      assert_response :success
      assert_contain @brief[:title].titlecase
    end

  end
  
  context "Access to briefs" do
    
    setup do
      @user = users(:henry)
      assert @brief = brief_for(users(:jason))
      
      login_as(@user)      
      visit briefs_path
      assert_equal '/briefs', path
    end
    
    should "see a list of other briefs even when user has none" do
      assert @user.briefs.empty?
      assert_contain @brief.title
    end
    
    should "be able to view a brief" do
      click_link 'show'
      assert_response :success
      assert_equal brief_path(@brief), path
    end
    
  end
  
  context "comments" do
    
    setup do
      @jason = users(:jason)
      @henry = users(:henry)
      @brief = brief_for(@jason)
      
      login_as(@henry)       
    end
    
    should "see comment form" do
      visit brief_path(@brief)
      assert_equal brief_path(@brief), path
      assert_have_selector("form#comment")
    end
    
  end

end
