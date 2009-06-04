require 'test_helper'

class BriefsControllerTest < ActionController::TestCase

  context "brief controller" do
    setup do
      @brief = Brief.make
      activate_authlogic
    end

    context "author" do
      setup do
        UserSession.create(@brief.author)
      end

      should "get index" do
        get :index
        assert_response :success
        assert assigns(:briefs)
      end
      
      should "get_new" do
        get :new
        assert_response :success
      end
      
      should "create brief" do
        old_count = Brief.count
        post :create, :brief => Brief.plan
        assert_equal old_count + 1, Brief.count

        assert_redirected_to brief_path(assigns(:brief))
      end
      
      should "show brief" do
        get :show, :id => @brief.id
        assert_response :success
      end
      
      should "get edit" do
        get :edit, :id => @brief.id
        assert_response :success
      end
      
      should "update brief" do
        put :update, :id => @brief.id, :brief => { :title => "Title update" }
        assert_redirected_to brief_path(assigns(:brief))
      end
      
      should "destroy brief" do
        old_count = Brief.count
        delete :destroy, :id => @brief.id
        assert_equal old_count-1, Brief.count

        assert_redirected_to briefs_path
      end
    end

    context "creative" do
      setup do
        @creative = Creative.make
        UserSession.create(@creative)
      end

      should "not be able to access new brief page" do
        get :new
        assert_redirected_to briefs_path
      end
      
      should "not be able to create a brief" do
        assert_no_difference "Brief.count" do
          post :create, :brief => Brief.plan
          assert_redirected_to briefs_path
        end
      end
      
      should "not be able to update a brief" do
        assert_difference "@brief.title", "" do
          put :update, :id => @brief.id, :brief => { :title => "Creative update" }
          assert_redirected_to briefs_path        
        end
      end
      
      should "not be able to delete a brief" do
        assert_no_difference "Brief.count" do
          delete :destroy, :id => @brief.id
          assert_redirected_to briefs_path
        end
      end
        
    end
    
    
  end
  
end
