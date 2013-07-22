#encoding:utf-8
class MySchool::MainController < MySchool::BaseController
  #幼儿园首页
  layout "colorful_main"
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

  #官网里面的圆所特色
  def feature
    render :layout=>"colorful_main"
  end

  #显示关于官网里面的关于幼儿园
  def show_official_about_us
  end
  #显示官网招生信息
  def admissions_information
  end
  
end
