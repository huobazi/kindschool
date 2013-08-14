#encoding:utf-8
class MySchool::MainController < MySchool::BaseController
  before_filter :find_shrink_record
  #幼儿园首页
  layout "colorful_main"
  def index
    if @kind 
      @news = @kind.news.where(:approve_status=>0).limit(6)
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
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_feature") 
      if root_showcase && !root_showcase.content_entries.blank?
       @content_entries = root_showcase.content_entries
      end
    end
  end

  #显示关于官网里面的关于幼儿园
  def show_official_about_us
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_about_us") 
      if root_showcase && !root_showcase.content_entries.blank?
       if content_entries = root_showcase.content_entries
         @entry = content_entries.find_by_number("official_website_about_us_content")
         @entry_title = content_entries.find_by_number("official_website_about_us_title")
         @entry_img = content_entries.find_by_number("official_website_about_us_img")
         @entry_top = content_entries.find_by_number("official_website_about_us_img_top")
         @entry_bottom = content_entries.find_by_number("official_website_about_us_img_bottom")
       end
      end
    end
  end
  #显示官网招生信息
  def admissions_information
    if @kind 
      root_showcase = @kind.page_contents.find_by_number("official_website_admissions_information") 
      if root_showcase && !root_showcase.content_entries.blank?
        @entry = root_showcase.content_entries.find_by_number("official_website_admissions_title")   
        @entry_mid = root_showcase.content_entries.find_by_number("official_website_admissions_mid_title")
      end
    end
  end

  def show_one_new
    @new = @kind.news.find(params[:new_id])
    @new.show_count = @new.show_count.to_i+1
    @new.save
    @new_pre = @kind.news.find(:first,:conditions=>["created_at>:create_at",{:create_at=>@new.created_at}])
    @new_next = @kind.news.find(:first,:conditions=>["created_at<:create_at",{:create_at=>@new.created_at}])
  end

  def show_new_list
    @news = @kind.news.where(:approve_status=>0).page(params[:page] || 1).per(10)
  end
  private
  def find_shrink_record
    if @kind && @kind.shrink_record
       @keywords = @kind.shrink_record.keywords
       @description = @kind.shrink_record.description
    end 

  end

end
