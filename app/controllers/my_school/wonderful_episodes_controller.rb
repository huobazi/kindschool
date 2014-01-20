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
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action=> :index
      return
    else current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    end
    if @grades = @kind.grades
      #    if @squads = @grades.first.squads
      #    end
    end
  end

  def create
    @wonderful_episode = WonderfulEpisode.new(params[:wonderful_episode])
    @wonderful_episode.kindergarten_id = @kind.id
    @wonderful_episode.user_id = current_user.id
    if @wonderful_episode.save
      flash[:success] = "创建成功"
      redirect_to :action => :show, :id => @wonderful_episode.id
    else
      flash[:error] = "创建失败"
      render :new
    end
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
