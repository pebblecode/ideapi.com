require 'test_helper'

class BriefsControllerTest < ActionController::TestCase
  include BriefWorkflowHelper
  
  context "any logged in user" do
    setup do
      @user = User.make  
      @brief = Brief.make(:published, { :user => @user })        
      
      login(@user)
    end
    
    context "showing brief" do
      setup do
        get :show, :id => @brief.id
      end

      should_assign_to :current_object
      should_respond_with :success
      should_render_template :show
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
    
  end
  
  context "a brief owner" do
    setup do
      @author = User.make  
      @brief = Brief.make(:published, { :user => @author })        
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
        should_render_template :index

        should "have brief in assigned collection" do
          assert_contains(assigns['current_objects'][:published], @brief)
        end

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
          @brief_count = Brief.count || 1
          @brief_count_after = @brief_count - 1
        end
    
        should_respond_with :redirect
        should_redirect_to("briefs index") { briefs_path }
        should_change "Brief.count", :from => @brief_count, :to => @brief_count_after
      end
    
      context "html fallback without js for deleting" do
        setup do
    
        end
        should "get delete page to confirm deletion"
      end
      
    end
        
  end
    
  context "a user who doesn't own the brief" do
    setup do 
      @user = User.make(:password => "testing")
      @brief = Brief.make(:published)
    end
    
    context "logged in" do
  
      setup do
        login(@user)
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
