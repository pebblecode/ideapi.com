require 'test_helper'

class Admin::BriefSectionsControllerTest < ActionController::TestCase

  def setup
    @section = BriefSection.make
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:brief_sections)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_section
    old_count = BriefSection.count
    post :create, :brief_section => BriefSection.plan
    assert_equal old_count + 1, BriefSection.count
  
    assert_redirected_to admin_brief_section_path(assigns(:brief_section))
  end
  
  def test_should_show_section
    get :show, :id => @section.id
    assert_redirected_to edit_admin_brief_section_path(@section)
  end
  
  def test_should_get_edit
    get :edit, :id => @section.id
    assert_response :success
  end
  
  def test_should_update_section
    put :update, :id => @section.id, :brief_section => { :title => "title update" }
    assert_redirected_to admin_brief_section_path(assigns(:brief_section))
  end
  
  def test_should_destroy_section
    old_count = BriefSection.count
    delete :destroy, :id => @section.id
    assert_equal old_count-1, BriefSection.count
  
    assert_redirected_to admin_brief_sections_path
  end
end
