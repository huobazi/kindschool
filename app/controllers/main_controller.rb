#encoding:utf-8
class MainController < ApplicationController
  #平台首页
  def index
    if @subdomain.blank? || @subdomain == "www"
    else
      if kind = Kindergarten.find_by_number(@subdomain)
        redirect_to :controller=>"/my_school/main",:action=>"index"
        return
      else
        @no_kind = true
      end
    end
  end
end
