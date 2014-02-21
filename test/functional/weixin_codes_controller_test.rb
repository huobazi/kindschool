require 'test_helper'

class WeixinCodesControllerTest < ActionController::TestCase
  setup do
    @weixin_code = weixin_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weixin_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weixin_code" do
    assert_difference('WeixinCode.count') do
      post :create, weixin_code: { kindergarten_id: @weixin_code.kindergarten_id, user_id: @weixin_code.user_id, weixin_code: @weixin_code.weixin_code, weixin_tp: @weixin_code.weixin_tp }
    end

    assert_redirected_to weixin_code_path(assigns(:weixin_code))
  end

  test "should show weixin_code" do
    get :show, id: @weixin_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weixin_code
    assert_response :success
  end

  test "should update weixin_code" do
    put :update, id: @weixin_code, weixin_code: { kindergarten_id: @weixin_code.kindergarten_id, user_id: @weixin_code.user_id, weixin_code: @weixin_code.weixin_code, weixin_tp: @weixin_code.weixin_tp }
    assert_redirected_to weixin_code_path(assigns(:weixin_code))
  end

  test "should destroy weixin_code" do
    assert_difference('WeixinCode.count', -1) do
      delete :destroy, id: @weixin_code
    end

    assert_redirected_to weixin_codes_path
  end
end
