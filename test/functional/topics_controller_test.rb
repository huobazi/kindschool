require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
  setup do
    @topic = topics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:topics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create topic" do
    assert_difference('Topic.count') do
      post :create, topic: { approve_status: @topic.approve_status, approver_id: @topic.approver_id, content: @topic.content, creater_id: @topic.creater_id, is_show: @topic.is_show, is_top: @topic.is_top, kindergarten_id: @topic.kindergarten_id, show_count: @topic.show_count, squad_id: @topic.squad_id, status: @topic.status, title: @topic.title, tp: @topic.tp }
    end

    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should show topic" do
    get :show, id: @topic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @topic
    assert_response :success
  end

  test "should update topic" do
    put :update, id: @topic, topic: { approve_status: @topic.approve_status, approver_id: @topic.approver_id, content: @topic.content, creater_id: @topic.creater_id, is_show: @topic.is_show, is_top: @topic.is_top, kindergarten_id: @topic.kindergarten_id, show_count: @topic.show_count, squad_id: @topic.squad_id, status: @topic.status, title: @topic.title, tp: @topic.tp }
    assert_redirected_to topic_path(assigns(:topic))
  end

  test "should destroy topic" do
    assert_difference('Topic.count', -1) do
      delete :destroy, id: @topic
    end

    assert_redirected_to topics_path
  end
end
