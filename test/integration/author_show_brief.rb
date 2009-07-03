require 'test_helper'

class AuthorShowBrief < ActionController::IntegrationTest
  include BriefWorkflowHelper

  context "author" do
    setup do
      @author = Author.make(:password => "testing")
      login_as(@author)
      
      @draft = Brief.make(:author => @author)
    end

    context "general" do
      setup do
        visit brief_path(@draft)
      end
      
      should "access page" do
        assert_response :success
        assert_equal brief_path(@draft), path
      end

      should "have page title with brief title and edit link" do
        within '.title_holder' do |scope|
          assert_contain(@draft.title)
          scope.click_link "edit brief"
          assert_response :success
          assert_equal edit_brief_path(@draft), path
        end
      end
            
    end
    
    context "other authors briefs" do
      setup do
        other_author = Author.make(:password => "testing")
        @brief = Brief.make(:author => other_author)
        assert !@author.briefs.include?(@brief) 
      end

      should "not be able to access other authors briefs" do
        visit brief_path(@brief)
        assert_equal briefs_path, path
      end
    end
    
    context "layout" do
      setup do
        visit brief_path(@draft)
      end

      should "show most important text" do
        assert_contain @draft.most_important_message
      end
      
      should "have links to overview / questions / inspiration" do
         within '.tabbed_links' do |scope|
           assert_select 'span.current', :text => "Overview"
           scope.click_link 'questions'
           # scope.click_link 'inspiration'
         end
      end
      
      context "brief document" do
        setup do
          populate_brief(@draft)
          visit brief_path(@draft)
        end

        should "has brief items" do
          assert !@draft.brief_items.empty?
        end
        
        should "display the brief items" do
          @draft.brief_items.each do |item| 
            assert_contain(item.title)
            assert_contain(item.body) 
          end
        end
        
      end
      
    end
    
    
  end
  
end