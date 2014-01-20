require 'test_helper'

class WonderfulEpisodesControllerTest < ActionController::TestCase
  setup do
    @wonderful_episode = wonderful_episodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wonderful_episodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wonderful_episode" do
    assert_difference('WonderfulEpisode.count') do
      post :create, wonderful_episode: { is_top: @wonderful_episode.is_top, kindergarten_id: @wonderful_episode.kindergarten_id, squad_id: @wonderful_episode.squad_id, title: @wonderful_episode.title, url_address: @wonderful_episode.url_address }
    end

    assert_redirected_to wonderful_episode_path(assigns(:wonderful_episode))
  end

  test "should show wonderful_episode" do
    get :show, id: @wonderful_episode
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wonderful_episode
    assert_response :success
  end

  test "should update wonderful_episode" do
    put :update, id: @wonderful_episode, wonderful_episode: { is_top: @wonderful_episode.is_top, kindergarten_id: @wonderful_episode.kindergarten_id, squad_id: @wonderful_episode.squad_id, title: @wonderful_episode.title, url_address: @wonderful_episode.url_address }
    assert_redirected_to wonderful_episode_path(assigns(:wonderful_episode))
  end

  test "should destroy wonderful_episode" do
    assert_difference('WonderfulEpisode.count', -1) do
      delete :destroy, id: @wonderful_episode
    end

    assert_redirected_to wonderful_episodes_path
  end
end
