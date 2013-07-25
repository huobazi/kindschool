#encoding:utf-8
class Weixin::ActivitiesController < Weixin::ManageController
  def index
    @activities = @kind.activities.page(params[:page] || 1).per(10).order("created_at DESC")

  end

  def show
    @activity = @kind.activities.find_by_id(params[:id])
  end

  def new
    @activity = Activity.new
    @activity.creater_id = current_user.id
    @activity.kindergarten_id = @kind.id
  end

  def create
    @activity = @kind.activities.find_by_id(params[:id])

    if @activity.save!
      flash[:success] = "创建"
    else
    end
  end

end


