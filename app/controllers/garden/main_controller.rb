#encoding:utf-8
class Garden::MainController < Garden::BaseController

  def index
    @web_garden_kindergarten = WeiyiConfig.find_by_number("web_garden_kindergarten")
  end
  
end
