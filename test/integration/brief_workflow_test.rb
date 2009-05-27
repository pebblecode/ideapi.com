require 'test_helper'

class BriefWorkflowTest < ActionController::IntegrationTest
  
  fixtures :users
  
  context "Creating a brief" do
    setup do
      @user = users(:jason)
      @brief = Brief.plan
      
      visit new_user_session_path  
      assert_response :success  
      fill_in "login", :with => @user.login
      fill_in "password", :with => "testing"
      click_button
      assert_equal '/', path
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

end
