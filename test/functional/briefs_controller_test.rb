require 'test_helper'

class BriefsControllerTest < ActionController::TestCase
  include BriefWorkflowHelper
  
  context "an author" do
    setup do
      @author = Author.make  
      @brief = Brief.make(:published, { :author => @author })        
    end
    
    context "when logged in" do
      setup do
        login(@author)
      end
      
      context "visiting briefs index" do
        setup do
          get :index
        end

        should_assign_to :current_objects
        should_respond_with :success
        should_render_template :index_author

        should "have authors brief in assigned collection" do
          assert_contains(assigns['current_objects'], @brief)
        end

      end

      context "showing brief" do
        setup do
          get :show, :id => @brief.id
        end

        should_assign_to :current_object
        should_respond_with :success
        should_render_template :show_author
      end

      context "new brief" do
        setup do
          get :new
        end
    
        should_assign_to :current_object
        should_respond_with :success
        should_render_template :new
      end
    
      context "create brief" do
        setup do
          post :create, :brief => Brief.plan
        end
    
        should_change "Brief.count", :by => 1
        should_assign_to :current_object
        should_respond_with :redirect
        should_redirect_to("viewing the brief") { edit_brief_path(assigns['current_object']) }
      end
    
    
      context "edit brief" do
        setup do
          get :edit, :id => @brief.id
        end
    
        should_assign_to :current_object
        should_respond_with :success
        should_render_template :edit
      end
    
      context "update brief" do
        setup do
          @title_update = "boom boom"
          put :update, :id => @brief.id, :brief => { :title => @title_update }
        end
    
        should_assign_to :current_object
        should_respond_with :redirect
        should_redirect_to("viewing the brief") { edit_brief_path(@brief) }
    
        should "update object" do
          assert_equal(@title_update, assigns['current_object'].title)
        end
      end
    
      context "deleting brief" do
        setup do
          delete :destroy, :id => @brief.id
        end
    
        should_respond_with :redirect
        should_redirect_to("briefs index") { briefs_path }
        should_change "Brief.count", :from => 1, :to => 0
      end
    
      context "html fallback without js for deleting" do
        setup do
    
        end
        should "get delete page to confirm deletion"
      end
      
    end
        
  end
    
  context "creative" do
    setup do 
      @creative = Creative.make(:password => "testing")
      @brief = Brief.make(:published)
    end
    
    context "logged in" do
  
      setup do
        login(@creative)
      end
      
      should "not be able to get new brief" do
        get :new
        assert_response :redirect
      end
  
      should "not be able to post create briefs" do
        assert_no_difference "Brief.count" do
          post :create, :brief => Brief.plan
          assert_redirected_to briefs_path        
        end
      end
  
      should "not be able to get edit brief" do
        get :edit, :id => @brief.id
        assert_response :redirect
      end
  
      should "not be able to put update" do
        title_update = "boom shkalaka"
        title_before = @brief.title
  
        put :update, :id => @brief.id, :brief => { :title => title_update }
        assert_equal(title_before, @brief.reload.title)
      end
  
      should "not be able to get delete brief"
  
      should "not be able to delete brief" do
        assert_no_difference "Brief.count" do
          delete :destroy, :id => @brief.id
          assert_redirected_to briefs_path
        end
      end
      
    end
  end
  
end
