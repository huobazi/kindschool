require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    @album = albums(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:albums)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create album" do
    assert_difference('Album.count') do
      post :create, album: { approve_status: @album.approve_status, approver_id: @album.approver_id, content: @album.content, creater_id: @album.creater_id, grade_id: @album.grade_id, is_show: @album.is_show, kindergarten_id: @album.kindergarten_id, send_date: @album.send_date, squad_id: @album.squad_id, squad_name: @album.squad_name, title: @album.title, tp: @album.tp }
    end

    assert_redirected_to album_path(assigns(:album))
  end

  test "should show album" do
    get :show, id: @album
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @album
    assert_response :success
  end

  test "should update album" do
    put :update, id: @album, album: { approve_status: @album.approve_status, approver_id: @album.approver_id, content: @album.content, creater_id: @album.creater_id, grade_id: @album.grade_id, is_show: @album.is_show, kindergarten_id: @album.kindergarten_id, send_date: @album.send_date, squad_id: @album.squad_id, squad_name: @album.squad_name, title: @album.title, tp: @album.tp }
    assert_redirected_to album_path(assigns(:album))
  end

  test "should destroy album" do
    assert_difference('Album.count', -1) do
      delete :destroy, id: @album
    end

    assert_redirected_to albums_path
  end
end
