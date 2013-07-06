require 'test_helper'

class CareerStrategiesControllerTest < ActionController::TestCase
  setup do
    @career_strategy = career_strategies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:career_strategies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create career_strategy" do
    assert_difference('CareerStrategy.count') do
      post :create, career_strategy: { add_squad: @career_strategy.add_squad, from_id: @career_strategy.from_id, graduation: @career_strategy.graduation, kindergarten_id: @career_strategy.kindergarten_id, to_id: @career_strategy.to_id }
    end

    assert_redirected_to career_strategy_path(assigns(:career_strategy))
  end

  test "should show career_strategy" do
    get :show, id: @career_strategy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @career_strategy
    assert_response :success
  end

  test "should update career_strategy" do
    put :update, id: @career_strategy, career_strategy: { add_squad: @career_strategy.add_squad, from_id: @career_strategy.from_id, graduation: @career_strategy.graduation, kindergarten_id: @career_strategy.kindergarten_id, to_id: @career_strategy.to_id }
    assert_redirected_to career_strategy_path(assigns(:career_strategy))
  end

  test "should destroy career_strategy" do
    assert_difference('CareerStrategy.count', -1) do
      delete :destroy, id: @career_strategy
    end

    assert_redirected_to career_strategies_path
  end
end
