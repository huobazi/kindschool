require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase
  setup do
    @activity = activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity" do
    assert_difference('Activity.count') do
      post :create, activity: { approve_status: @activity.approve_status, approver_id: @activity.approver_id, content: @activity.content, creater_id: @activity.creater_id, end_at: @activity.end_at, kindergarten_id: @activity.kindergarten_id, logo: @activity.logo, note: @activity.note, send_range: @activity.send_range, send_range_ids: @activity.send_range_ids, start_at: @activity.start_at, title: @activity.title, tp: @activity.tp }
    end

    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should show activity" do
    get :show, id: @activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity
    assert_response :success
  end

  test "should update activity" do
    put :update, id: @activity, activity: { approve_status: @activity.approve_status, approver_id: @activity.approver_id, content: @activity.content, creater_id: @activity.creater_id, end_at: @activity.end_at, kindergarten_id: @activity.kindergarten_id, logo: @activity.logo, note: @activity.note, send_range: @activity.send_range, send_range_ids: @activity.send_range_ids, start_at: @activity.start_at, title: @activity.title, tp: @activity.tp }
    assert_redirected_to activity_path(assigns(:activity))
  end

  test "should destroy activity" do
    assert_difference('Activity.count', -1) do
      delete :destroy, id: @activity
    end

    assert_redirected_to activities_path
  end
end
