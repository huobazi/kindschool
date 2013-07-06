#encoding:utf-8
class Weixin::MainController < Weixin::ApplicationController
  #平台首页
  def index
    if @subdomain == "" || @subdomain == "www"
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
