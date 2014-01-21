#encoding:utf-8
#微信端精彩视频管理
class Weixin::WonderfulEpisodesController < Weixin::ManageController
  def index
    @wonderful_episodes = WonderfulEpisode.all
  end

  def show
    @wonderful_episode = WonderfulEpisode.find(params[:id])
  end

  def new
    @wonderful_episode = WonderfulEpisode.new
  end

  def create
    @wonderful_episode = WonderfulEpisode.new(params[:wonderful_episode])
    @wonderful_episode.save
  end

  def edit
    @wonderful_episode = WonderfulEpisode.find(params[:id])

  end

  def update
    @wonderful_episode = WonderfulEpisode.find(params[:id])
    @wonderful_episode.update_attributes(params[:wonderful_episode])
  end

  def destroy
    @wonderful_episode = WonderfulEpisode.find(params[:id])
    @wonderful_episode.destroy
  end
end
