require 'test_helper'

class KindergartensControllerTest < ActionController::TestCase
  setup do
    @kindergarten = kindergartens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kindergartens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kindergarten" do
    assert_difference('Kindergarten.count') do
      post :create, kindergarten: { logo: @kindergarten.logo, name: @kindergarten.name, note: @kindergarten.note, number: @kindergarten.number, status: @kindergarten.status }
    end

    assert_redirected_to kindergarten_path(assigns(:kindergarten))
  end

  test "should show kindergarten" do
    get :show, id: @kindergarten
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kindergarten
    assert_response :success
  end

  test "should update kindergarten" do
    put :update, id: @kindergarten, kindergarten: { logo: @kindergarten.logo, name: @kindergarten.name, note: @kindergarten.note, number: @kindergarten.number, status: @kindergarten.status }
    assert_redirected_to kindergarten_path(assigns(:kindergarten))
  end

  test "should destroy kindergarten" do
    assert_difference('Kindergarten.count', -1) do
      delete :destroy, id: @kindergarten
    end

    assert_redirected_to kindergartens_path
  end
end
