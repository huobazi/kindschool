#encoding:utf-8
#精彩视频管理
class MySchool::WonderfulEpisodesController < MySchool::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @wonderful_episodes = @kind.wonderful_episodes.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @wonderful_episodes = @kind.wonderful_episodes.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1)
    else
      @wonderful_episodes = @kind.wonderful_episodes.page(params[:page] || 1)
    end
  end

  def show
    @wonderful_episode = WonderfulEpisode.find(params[:id])
    ActiveRecord::Base.transaction do
      @wonderful_episode.show_count =@wonderful_episode.show_count.to_i + 1
      @wonderful_episode.save
    end
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
    if @grades = @kind.grades
      if current_user.get_users_ranges[:tp] == :all
        if @squads = @grades.first.squads.where(:graduate => false)
        end
      elsif current_user.get_users_ranges[:tp] == :teachers
        @squads = current_user.get_users_ranges[:squads]
      end
    end
    if @squad = @wonderful_episode.squad
      @grade = @squad.grade
    else
      if current_user.get_users_ranges[:tp] == :all
        @squads  = []
      end
    end
  end

  def update
    @wonderful_episode = WonderfulEpisode.find(params[:id])
    if @wonderful_episode.update_attributes(params[:wonderful_episode])
      flash[:success] = "修改成功"
      redirect_to :action => :show, :id => @wonderful_episode.id
    else
      flash[:error] = "修改失败"
      render :edit
    end
  end

  def destroy
    @wonderful_episode = WonderfulEpisode.find(params[:id])
    @wonderful_episode.destroy
  end
end
