require 'test_helper'

class MessageEntriesControllerTest < ActionController::TestCase
  setup do
    @message_entry = message_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_entry" do
    assert_difference('MessageEntry.count') do
      post :create, message_entry: { content: @message_entry.content, message_id: @message_entry.message_id, phone: @message_entry.phone, receiver_id: @message_entry.receiver_id, receiver_name: @message_entry.receiver_name, sms: @message_entry.sms, status: @message_entry.status }
    end

    assert_redirected_to message_entry_path(assigns(:message_entry))
  end

  test "should show message_entry" do
    get :show, id: @message_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message_entry
    assert_response :success
  end

  test "should update message_entry" do
    put :update, id: @message_entry, message_entry: { content: @message_entry.content, message_id: @message_entry.message_id, phone: @message_entry.phone, receiver_id: @message_entry.receiver_id, receiver_name: @message_entry.receiver_name, sms: @message_entry.sms, status: @message_entry.status }
    assert_redirected_to message_entry_path(assigns(:message_entry))
  end

  test "should destroy message_entry" do
    assert_difference('MessageEntry.count', -1) do
      delete :destroy, id: @message_entry
    end

    assert_redirected_to message_entries_path
  end
end
