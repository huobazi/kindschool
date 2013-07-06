require 'test_helper'

class ActivityEntriesControllerTest < ActionController::TestCase
  setup do
    @activity_entry = activity_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:activity_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create activity_entry" do
    assert_difference('ActivityEntry.count') do
      post :create, activity_entry: { activity_id: @activity_entry.activity_id, creater_id: @activity_entry.creater_id, note: @activity_entry.note, tp: @activity_entry.tp }
    end

    assert_redirected_to activity_entry_path(assigns(:activity_entry))
  end

  test "should show activity_entry" do
    get :show, id: @activity_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @activity_entry
    assert_response :success
  end

  test "should update activity_entry" do
    put :update, id: @activity_entry, activity_entry: { activity_id: @activity_entry.activity_id, creater_id: @activity_entry.creater_id, note: @activity_entry.note, tp: @activity_entry.tp }
    assert_redirected_to activity_entry_path(assigns(:activity_entry))
  end

  test "should destroy activity_entry" do
    assert_difference('ActivityEntry.count', -1) do
      delete :destroy, id: @activity_entry
    end

    assert_redirected_to activity_entries_path
  end
end
