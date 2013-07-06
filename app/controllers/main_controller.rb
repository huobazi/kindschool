#encoding:utf-8
class MainController < ApplicationController
  #平台首页
  def index
    puts "==============@subdomain===#{@subdomain}"
    if @subdomain == "" || @subdomain == "www"
    else
      if kind = Kindergarten.find_by_number(@subdomain)
        puts "====kind======#{kind.name}========"
        redirect_to :controller=>"/my_school/main",:action=>"index"
        return
      else
        puts "====no kind======="
        @no_kind = true
      end
    end
  end
end
