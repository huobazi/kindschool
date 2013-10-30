#encoding:utf-8
#经典用户
class Garden::ClassicUsersController < Garden::BaseController
  def index
    @classic_users = WeiyiConfig.find_by_number("web_garden_classic_users")
  end
end
