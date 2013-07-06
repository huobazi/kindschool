require 'test_helper'

class NoticesControllerTest < ActionController::TestCase
  setup do
    @notice = notices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notice" do
    assert_difference('Notice.count') do
      post :create, notice: { approve_status: @notice.approve_status, approver_id: @notice.approver_id, content: @notice.content, creater_id: @notice.creater_id, kindergarten_id: @notice.kindergarten_id, send_date: @notice.send_date, send_range: @notice.send_range, send_range_ids: @notice.send_range_ids, status: @notice.status, title: @notice.title }
    end

    assert_redirected_to notice_path(assigns(:notice))
  end

  test "should show notice" do
    get :show, id: @notice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notice
    assert_response :success
  end

  test "should update notice" do
    put :update, id: @notice, notice: { approve_status: @notice.approve_status, approver_id: @notice.approver_id, content: @notice.content, creater_id: @notice.creater_id, kindergarten_id: @notice.kindergarten_id, send_date: @notice.send_date, send_range: @notice.send_range, send_range_ids: @notice.send_range_ids, status: @notice.status, title: @notice.title }
    assert_redirected_to notice_path(assigns(:notice))
  end

  test "should destroy notice" do
    assert_difference('Notice.count', -1) do
      delete :destroy, id: @notice
    end

    assert_redirected_to notices_path
  end
end
