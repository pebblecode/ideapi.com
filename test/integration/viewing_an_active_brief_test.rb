require 'test_helper'

class ViewingAnActiveBriefTest < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "all users" do
    
    setup do
      # we dont care what type of user
      @user = User.make(:password => "testing")
      login_as(@user)
      
      @brief = Brief.make
    end

    should "be able to view a brief" do
      visit brief_path(@brief)
      assert_response :success
      assert_equal(brief_path(@brief), path)
    end
    
    context "linking to questions to brief item" do
      
      setup do
        
      end
    
      should "have general ask a question link" do
        
      end
    #   
    #   should "have specific ask a question links tied to a brief item" do
    #     
    #   end
    #   
    #   should "have question count for each brief item" do
    #   end
    #   
    #   should "show any author answers to a question linked to a brief item" do
    #     
    #   end
    #   
    end
    
  end
  
  # context "author" do
  #   setup do
  #     
  #   end
  # 
  #   should "description" do
  #     
  #   end
  # end
  # 
  # context "creative" do
  #   setup do
  #     
  #   end
  # 
  #   should "description" do
  #     
  #   end
  # end

end
