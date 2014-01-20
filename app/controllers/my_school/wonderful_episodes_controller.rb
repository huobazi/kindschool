#encoding:utf-8
#精彩视频管理
class MySchool::WonderfulEpisodesController < MySchool::ManageController
  def index
    @wonderful_episodes = @kind.wonderful_episodes.page(params[:page] || 1)
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
