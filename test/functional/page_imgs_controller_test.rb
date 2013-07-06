require 'test_helper'

class PageImgsControllerTest < ActionController::TestCase
  setup do
    @page_img = page_imgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:page_imgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page_img" do
    assert_difference('PageImg.count') do
      post :create, page_img: { alt: @page_img.alt, content_entry_id: @page_img.content_entry_id, content_type: @page_img.content_type, created_at: @page_img.created_at, filename: @page_img.filename, height: @page_img.height, kindergarten_id: @page_img.kindergarten_id, parent_id: @page_img.parent_id, resource_id: @page_img.resource_id, resource_type: @page_img.resource_type, size: @page_img.size, thumbnail: @page_img.thumbnail, width: @page_img.width }
    end

    assert_redirected_to page_img_path(assigns(:page_img))
  end

  test "should show page_img" do
    get :show, id: @page_img
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page_img
    assert_response :success
  end

  test "should update page_img" do
    put :update, id: @page_img, page_img: { alt: @page_img.alt, content_entry_id: @page_img.content_entry_id, content_type: @page_img.content_type, created_at: @page_img.created_at, filename: @page_img.filename, height: @page_img.height, kindergarten_id: @page_img.kindergarten_id, parent_id: @page_img.parent_id, resource_id: @page_img.resource_id, resource_type: @page_img.resource_type, size: @page_img.size, thumbnail: @page_img.thumbnail, width: @page_img.width }
    assert_redirected_to page_img_path(assigns(:page_img))
  end

  test "should destroy page_img" do
    assert_difference('PageImg.count', -1) do
      delete :destroy, id: @page_img
    end

    assert_redirected_to page_imgs_path
  end
end
