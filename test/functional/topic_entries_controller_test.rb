require 'test_helper'

class TopicEntriesControllerTest < ActionController::TestCase
  setup do
    @topic_entry = topic_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topic_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic_entry" do
    assert_difference('TopicEntry.count') do
      post :create, topic_entry: { content: @topic_entry.content, creater_id: @topic_entry.creater_id, status: @topic_entry.status, topic_id: @topic_entry.topic_id }
    end

    assert_redirected_to topic_entry_path(assigns(:topic_entry))
  end

  test "should show topic_entry" do
    get :show, id: @topic_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic_entry
    assert_response :success
  end

  test "should update topic_entry" do
    put :update, id: @topic_entry, topic_entry: { content: @topic_entry.content, creater_id: @topic_entry.creater_id, status: @topic_entry.status, topic_id: @topic_entry.topic_id }
    assert_redirected_to topic_entry_path(assigns(:topic_entry))
  end

  test "should destroy topic_entry" do
    assert_difference('TopicEntry.count', -1) do
      delete :destroy, id: @topic_entry
    end

    assert_redirected_to topic_entries_path
  end
end
