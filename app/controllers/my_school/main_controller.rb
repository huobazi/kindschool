#encoding:utf-8
class MySchool::MainController < MySchool::BaseController
  #幼儿园首页
  layout "colorful_main"
  def index
    if @kind 
      @news = @kind.news.limit(6)
      root_showcase = @kind.page_contents.find_by_number("official_website_home")
      if root_showcase && !root_showcase.content_entries.blank?
        @teacher_infos = root_showcase.content_entries.where(:number=>"official_home_teacher")
        @img= root_showcase.content_entries.where(:number=>'official_home_pub_img')     
      end
    end 
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

  def show_one_new
    @new = @kind.news.find(params[:new_id])
  end

  def show_new_list
    @news = @kind.news.page(params[:page] || 1).per(10)
  end

end
