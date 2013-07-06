#encoding:utf-8
class MySchool::MainController < MySchool::BaseController
  #幼儿园首页
  def index
   
  end

  #提示界面
  def no_kindergarten
    render :layout=>"colorful_main"
  end
  #关于我们
  def about
    render :layout=>"colorful_main"
  end
  #联系我们
  def contact_us
    render :layout=>"colorful_main"
  end

  
end
