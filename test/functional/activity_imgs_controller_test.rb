require 'test_helper'

class ActivityImgsControllerTest < ActionController::TestCase
  setup do
    @activity_img = activity_imgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_imgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity_img" do
    assert_difference('ActivityImg.count') do
      post :create, activity_img: { alt: @activity_img.alt, content_type: @activity_img.content_type, created_at: @activity_img.created_at, filename: @activity_img.filename, height: @activity_img.height, parent_id: @activity_img.parent_id, resource_id: @activity_img.resource_id, resource_type: @activity_img.resource_type, size: @activity_img.size, thumbnail: @activity_img.thumbnail, width: @activity_img.width }
    end

    assert_redirected_to activity_img_path(assigns(:activity_img))
  end

  test "should show activity_img" do
    get :show, id: @activity_img
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity_img
    assert_response :success
  end

  test "should update activity_img" do
    put :update, id: @activity_img, activity_img: { alt: @activity_img.alt, content_type: @activity_img.content_type, created_at: @activity_img.created_at, filename: @activity_img.filename, height: @activity_img.height, parent_id: @activity_img.parent_id, resource_id: @activity_img.resource_id, resource_type: @activity_img.resource_type, size: @activity_img.size, thumbnail: @activity_img.thumbnail, width: @activity_img.width }
    assert_redirected_to activity_img_path(assigns(:activity_img))
  end

  test "should destroy activity_img" do
    assert_difference('ActivityImg.count', -1) do
      delete :destroy, id: @activity_img
    end

    assert_redirected_to activity_imgs_path
  end
end
