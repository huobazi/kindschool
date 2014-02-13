#encoding:utf-8
#微信端精彩视频管理
class Weixin::WonderfulEpisodesController < Weixin::ManageController

  include WonderfulEpisodesHelper
  def index
    if current_user.get_users_ranges[:tp] == :student
      @wonderful_episodes = @kind.wonderful_episodes.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @wonderful_episodes = @kind.wonderful_episodes.where("squad_id in (select squad_id from teachers where staff_id = ?) or user_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).page(params[:page] || 1)
    else
      @wonderful_episodes = @kind.wonderful_episodes.page(params[:page] || 1)
    end
    AccessStatu.update_unread(@kind, "WonderfulEpisode", current_user)
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
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to :action=> :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @wonderful_episode = @kind.wonderful_episodes.where("squad_id in (select squad_id from teachers where staff_id = ?) or user_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @wonderful_episode = @kind.wonderful_episodes.find(params[:id])
    end
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
    unless params[:wonderful_episode].blank? 
      @wonderful_episodes = @kind.wonderful_episodes.where(:id=>params[:wonderful_episode])
    else
      @wonderful_episodes = @kind.wonderful_episodes.where(:id=>params[:id])
    end
    if @wonderful_episodes.blank?
      flash[:error] = "请选择精彩视频"
      redirect_to :action => :index
      return
    end
    @wonderful_episodes.each do |wonderful_episode|
      wonderful_episode.destroy
    end
    respond_to do |format|
      flash[:success] = "删除精彩视频成功"
      format.html { redirect_to my_school_wonderful_episodes_path }
      format.json { head :no_content }
    end
  end
end
