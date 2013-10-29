#encoding:utf-8
#园讯通新闻
class Garden::GardenNewsController < Garden::BaseController
  def index
    @garden_news = GardenNew.page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @garden_new = GardenNew.find(params[:id])
  end

end
