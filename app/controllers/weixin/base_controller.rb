#encoding:utf-8
class Weixin::BaseController < ApplicationController
  before_filter :my_school
  before_filter :validate_nonce
  
  private
  def my_school
    if is_www?
      @required_type = :www
    else
      if @kind = Kindergarten.find_by_number(@subdomain)
        @required_type = :kindergarten
      else
        render :text=>"幼儿园不存在."
      end
    end
  end

  def is_www?
    return @subdomain == "" || @subdomain == "www"
  end


  def get_validate_data
    @validate_data = []
    @validate_data << (params[:nonce] || "")
    @validate_data << (params[:timestamp] || "")
    token = (@required_type == :www ? @kind.weixin_token : WEBSITE_CONFIG["weixin_token"])
    @validate_data << (token || "")
    @validate_data.sort.join("")
  end

  def validate_nonce
    if Digest::SHA1.hexdigest(get_validate_data) == params[:signature]
      if xml_data = params[:xml]
        @user =  User.find_by_weixin_code(xml_data[:FromUserName])
      else
        render :text=>"非法请求"
        return
      end
    else
      render :text=>"非法请求"
      return
    end
  end
end
