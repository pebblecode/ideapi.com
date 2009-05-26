require 'test_helper'

class Admin::SectionsControllerTest < ActionController::TestCase

  def setup
    @section = Section.make
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:sections)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_section
    old_count = Section.count
    post :create, :section => { }
    assert_equal old_count + 1, Section.count

    assert_redirected_to admin_section_path(assigns(:section))
  end

  def test_should_show_section
    get :show, :id => @section.id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => @section.id
    assert_response :success
  end

  def test_should_update_section
    put :update, :id => @section.id, :section => { }
    assert_redirected_to admin_section_path(assigns(:section))
  end

  def test_should_destroy_section
    old_count = Section.count
    delete :destroy, :id => @section.id
    assert_equal old_count-1, Section.count

    assert_redirected_to admin_sections_path
  end
end
