#encoding:utf-8
class MainController < ApplicationController
  include KindWeather
  #平台首页
  def index
    if @aliases_url
      if @kind = Kindergarten.find_by_aliases_url(@aliases_url)
        @news = @kind.news.where(:approve_status=>0).limit(6)
        root_showcase = @kind.page_contents.find_by_number("official_website_home")
        if root_showcase && !root_showcase.content_entries.blank?
          @teacher_infos = root_showcase.content_entries.where(:number=>"official_home_teacher")
          @img= root_showcase.content_entries.where(:number=>'official_home_pub_img')
        end
        @notices = @kind.notices.where(:send_range=>[0,2]).limit(6)
        cache_weather(@kind)
        find_shrink_record
        render "/my_school/main/index",:layout=>get_layout
        return
      else
        @no_kind = true
        @web_weiyi_about = WeiyiConfig.find_by_number("web_weiyi_about")
        render :layout=>"weiyi"
      end
    else
      if @subdomain.blank? || @subdomain == "www"
        @web_weiyi_about = WeiyiConfig.find_by_number("web_weiyi_about")
        render :layout=>"weiyi"
      else
        if @kind = Kindergarten.find_by_number(@subdomain)
          @news = @kind.news.where(:approve_status=>0).limit(6)
          root_showcase = @kind.page_contents.find_by_number("official_website_home")
          if root_showcase && !root_showcase.content_entries.blank?
            @teacher_infos = root_showcase.content_entries.where(:number=>"official_home_teacher")
            @img= root_showcase.content_entries.where(:number=>'official_home_pub_img')
          end
          @notices = @kind.notices.where(:send_range=>[0,2]).limit(6)
          cache_weather(@kind)
          find_shrink_record
          render "/my_school/main/index",:layout=>get_layout
          return
        else
          @no_kind = true
          @web_weiyi_about = WeiyiConfig.find_by_number("web_weiyi_about")
          render :layout=>"weiyi"
        end
      end
    end
  end

  
  def weiyi_solution
    render :layout=>"weiyi"
  end
  def weiyi_interact
    @web_weiyi_interact = WeiyiConfig.find_by_number("web_weiyi_interact")
    render :layout=>"weiyi"
  end
  def weiyi_contact
    @web_weiyi_contact = WeiyiConfig.find_by_number("web_weiyi_contact")
    render :layout=>"weiyi"
  end


  
  def weiyi_video
    @web_weiyi_video = WeiyiConfig.find_by_number("web_weiyi_video")
    render :layout=>"weiyi"
  end
  def weiyi_scheme
    @web_weiyi_scheme = WeiyiConfig.find_by_number("web_weiyi_scheme")
    render :layout=>"weiyi"
  end
  def weiyi_cultivate
    @web_weiyi_cultivate = WeiyiConfig.find_by_number("web_weiyi_cultivate")
    render :layout=>"weiyi"
  end
  def weiyi_benefit
    @web_weiyi_benefit = WeiyiConfig.find_by_number("web_weiyi_benefit")
    render :layout=>"weiyi"
  end

  def weiyi_tourism
    @web_weiyi_tourism = WeiyiConfig.find_by_number("weiyi_tourism")
    render :layout=>"weiyi"
  end


  private
  def find_shrink_record
    if @kind && @kind.shrink_record
      @keywords = @kind.shrink_record.keywords
      @description = @kind.shrink_record.description
      @baidu_seo = @kind.baidu_seo
    end
    @menu = "home"
    data = HOME_MENU || []
    data.each do |menu,value|
      if arr = value[controller_path.to_s]
        if arr.include?(action_name.to_s)
          @menu = menu
          break
        end
      end
    end
  end
end
