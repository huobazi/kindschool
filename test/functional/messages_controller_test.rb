require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    @message = messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message" do
    assert_difference('Message.count') do
      post :create, message: { approve_status: @message.approve_status, approver_id: @message.approver_id, chain_code: @message.chain_code, content: @message.content, entry_id: @message.entry_id, kindergarten_id: @message.kindergarten_id, parent_id: @message.parent_id, send_date: @message.send_date, sender_id: @message.sender_id, sender_name: @message.sender_name, status: @message.status, title: @message.title, tp: @message.tp }
    end

    assert_redirected_to message_path(assigns(:message))
  end

  test "should show message" do
    get :show, id: @message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message
    assert_response :success
  end

  test "should update message" do
    put :update, id: @message, message: { approve_status: @message.approve_status, approver_id: @message.approver_id, chain_code: @message.chain_code, content: @message.content, entry_id: @message.entry_id, kindergarten_id: @message.kindergarten_id, parent_id: @message.parent_id, send_date: @message.send_date, sender_id: @message.sender_id, sender_name: @message.sender_name, status: @message.status, title: @message.title, tp: @message.tp }
    assert_redirected_to message_path(assigns(:message))
  end

  test "should destroy message" do
    assert_difference('Message.count', -1) do
      delete :destroy, id: @message
    end

    assert_redirected_to messages_path
  end
end
