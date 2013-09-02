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
        render :layout=>"weiyi"
      end
    else
      if @subdomain.blank? || @subdomain == "www"
        render :layout=>"weiyi"
      else
        if Kindergarten.find_by_number(@subdomain)
          redirect_to :controller=>"/my_school/main",:action=>"index"
          return
        else
          @no_kind = true
          render :layout=>"weiyi"
        end
      end
    end
  end

  
  def weiyi_solution
    render :layout=>"weiyi"
  end
  def weiyi_interact
    render :layout=>"weiyi"
  end
  def weiyi_contact
    render :layout=>"weiyi"
  end
end
