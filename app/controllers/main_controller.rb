#encoding:utf-8
class MainController < ApplicationController
  #平台首页
  def index
    if @aliases_url
      if Kindergarten.find_by_aliases_url(@aliases_url)
        redirect_to :controller=>"/my_school/main",:action=>"index"
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
        if Kindergarten.find_by_number(@subdomain)
          redirect_to :controller=>"/my_school/main",:action=>"index"
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
end
