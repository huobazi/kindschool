require 'test_helper'

class AlbumEntriesControllerTest < ActionController::TestCase
  setup do
    @album_entry = album_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:album_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create album_entry" do
    assert_difference('AlbumEntry.count') do
      post :create, album_entry: { album_id: @album_entry.album_id, asset_img_id: @album_entry.asset_img_id }
    end

    assert_redirected_to album_entry_path(assigns(:album_entry))
  end

  test "should show album_entry" do
    get :show, id: @album_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @album_entry
    assert_response :success
  end

  test "should update album_entry" do
    put :update, id: @album_entry, album_entry: { album_id: @album_entry.album_id, asset_img_id: @album_entry.asset_img_id }
    assert_redirected_to album_entry_path(assigns(:album_entry))
  end

  test "should destroy album_entry" do
    assert_difference('AlbumEntry.count', -1) do
      delete :destroy, id: @album_entry
    end

    assert_redirected_to album_entries_path
  end
end
