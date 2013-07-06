require 'test_helper'

class ContentPatternsControllerTest < ActionController::TestCase
  setup do
    @content_pattern = content_patterns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:content_patterns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content_pattern" do
    assert_difference('ContentPattern.count') do
      post :create, content_pattern: { content: @content_pattern.content, kindergarten_id: @content_pattern.kindergarten_id, number: @content_pattern.number }
    end

    assert_redirected_to content_pattern_path(assigns(:content_pattern))
  end

  test "should show content_pattern" do
    get :show, id: @content_pattern
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @content_pattern
    assert_response :success
  end

  test "should update content_pattern" do
    put :update, id: @content_pattern, content_pattern: { content: @content_pattern.content, kindergarten_id: @content_pattern.kindergarten_id, number: @content_pattern.number }
    assert_redirected_to content_pattern_path(assigns(:content_pattern))
  end

  test "should destroy content_pattern" do
    assert_difference('ContentPattern.count', -1) do
      delete :destroy, id: @content_pattern
    end

    assert_redirected_to content_patterns_path
  end
end
