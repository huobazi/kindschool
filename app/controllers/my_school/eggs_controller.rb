#encoding:utf-8
#彩蛋功能
require 'mime/types'
class MySchool::EggsController  < MySchool::ManageController
  layout "eggs"
  def index
 
  end

  def get_egg
    render :json=>{"msg"=>1,"prize"=>"中奖100万"}
  end

  def my_prizes

  end

  def get_prize
   @prize = @kind.prize_logs.find_by_user_id_and_id(current_user,params[:id])
  end
end
