require 'test_helper'

class AuthorShowBrief < ActionController::IntegrationTest
  include BriefWorkflowHelper
  include ActionView::Helpers::TextHelper

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
      
      should_respond_with :success
      
      should "access page" do
        assert_equal brief_path(@draft), path
      end

      context "page title" do

        should "have the brief title" do
          assert_contain(truncate(@draft.title.downcase, :length => 30))
        end
        
        should "have edit link" do
          assert_select '.what_user_is_doing h3 a[href=?]', edit_brief_path(@draft), :text => '(edit)'
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
        assert_select 'a[href=?]', edit_brief_path(@brief), {:text => 'edit brief', :count => 0}
      end
    end
    
    context "layout" do
      setup do
        visit brief_path(@draft)
      end

      should "show most important text" do
        assert_contain @draft.most_important_message
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
    
    context "published document" do
      setup do
        @published = Brief.make(:published, { :author => @author })
        visit brief_path(@published)
      end

      context "answered questions" do
        setup do
          @creative = Creative.make
        end

        should "appear within the brief document" do          
          check_for_questions(@published, @creative)
        end
      end

    end
    
  end
  
end