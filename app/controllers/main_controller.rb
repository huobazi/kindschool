#encoding:utf-8
class MainController < ApplicationController
  #平台首页
  def index
    if @subdomain.blank? || @subdomain == "www"
      render :layout=>"weiyi"
    else
      if kind = Kindergarten.find_by_number(@subdomain)
        redirect_to :controller=>"/my_school/main",:action=>"index"
        return
      else
        @no_kind = true
        render :layout=>"weiyi"
      end
    end
  end
end
