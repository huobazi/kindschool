#encoding:utf-8
class Weixin::BaseController < ApplicationController
  before_filter :my_school
  before_filter :validate_nonce
  
  private
  def my_school
    @kind = Kindergarten.first
#    if is_www?
#      @required_type = :www
#    else
#      if @kind = Kindergarten.find_by_number(@subdomain)
#        @required_type = :kindergarten
#      else
#        render :text=>"幼儿园不存在."
#      end
#    end
  end

  def is_www?
    return @subdomain == "" || @subdomain == "www"
  end

  #c897963afaebf0e3722422c9362c2f779ca511cd
  def get_validate_data
    @validate_data = []
    @validate_data << (params[:nonce] || "")
    @validate_data << (params[:timestamp] || "")
    token = (@required_type == :www ? @kind.weixin_token : WEBSITE_CONFIG["weixin_token"])
    @validate_data << (token || "")
    @validate_data.sort.join("")
  end

  def validate_nonce
    if params[:signature].blank?
      @current_user ||= session[:user] && User.find_by_id(session[:user]) || :false
    else
      if Digest::SHA1.hexdigest(get_validate_data) == params[:signature]
        if xml_data = params[:xml]
          if @current_user = User.find_by_weixin_code(xml_data[:FromUserName])
            session[:user] = @current_user.id
          else
            session[:user] = nil
            @current_user = :false
          end
        end
      else
        render :text=>"请通过微信访问"
        return
      end
    end
    if @current_user == :false
      render :text=>"请通过微信访问"
      return
    end
  end
  def load_layout
    if @kind && @kind.template
      @kind.template.number
    else
      if template = Template.find_by_is_default(1)
        template.number
      else
        raise "模板信息缺失，请联系管理员"
      end
    end
  end
end
