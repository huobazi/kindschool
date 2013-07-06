require 'test_helper'

class ReadEntriesControllerTest < ActionController::TestCase
  setup do
    @read_entry = read_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:read_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create read_entry" do
    assert_difference('ReadEntry.count') do
      post :create, read_entry: { topic_id: @read_entry.topic_id, user_id: @read_entry.user_id }
    end

    assert_redirected_to read_entry_path(assigns(:read_entry))
  end

  test "should show read_entry" do
    get :show, id: @read_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @read_entry
    assert_response :success
  end

  test "should update read_entry" do
    put :update, id: @read_entry, read_entry: { topic_id: @read_entry.topic_id, user_id: @read_entry.user_id }
    assert_redirected_to read_entry_path(assigns(:read_entry))
  end

  test "should destroy read_entry" do
    assert_difference('ReadEntry.count', -1) do
      delete :destroy, id: @read_entry
    end

    assert_redirected_to read_entries_path
  end
end
