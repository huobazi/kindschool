require 'test_helper'

class StudentResourcesControllerTest < ActionController::TestCase
  setup do
    @student_resource = student_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_resource" do
    assert_difference('StudentResource.count') do
      post :create, student_resource: { student_info_id: @student_resource.student_info_id }
    end

    assert_redirected_to student_resource_path(assigns(:student_resource))
  end

  test "should show student_resource" do
    get :show, id: @student_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_resource
    assert_response :success
  end

  test "should update student_resource" do
    put :update, id: @student_resource, student_resource: { student_info_id: @student_resource.student_info_id }
    assert_redirected_to student_resource_path(assigns(:student_resource))
  end

  test "should destroy student_resource" do
    assert_difference('StudentResource.count', -1) do
      delete :destroy, id: @student_resource
    end

    assert_redirected_to student_resources_path
  end
end
