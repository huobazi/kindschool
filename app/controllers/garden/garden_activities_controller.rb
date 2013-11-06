#encoding:utf-8
#园讯通活动
class Garden::GardenActivitiesController < Garden::BaseController
  def index
    @garden_activities = GardenActivitie.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @garden_activitie = GardenActivitie.find(params[:id])
  end
end
