#encoding:utf-8
class Weixin::BaseController < ApplicationController
  before_filter :my_school
  before_filter :validate_nonce
  include AuthenticatedSystem

  protected
  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to url_for(:controller=>"/weixin/users",:action=>:login)
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
    end
    false
  end

  
  protected
  def is_www?
    return @subdomain == "www" || @subdomain.blank? || @subdomain == "weiyi"
  end
  private
  def my_school
    #    @kind = Kindergarten.first
    if is_www?
      @required_type = :www
    else
      if @kind = Kindergarten.find_by_number(@subdomain)
        @required_type = :kindergarten
        @topic_categories = @kind.topic_categories
      else
        render :text=>"幼儿园不存在."
      end
    end
  end



  def get_validate_data
    @validate_data = []
    @validate_data << (params[:nonce] || "")
    @validate_data << (params[:timestamp] || "")
    token = is_www? ? WEBSITE_CONFIG["weixin_token"] : @kind.weixin_token
    #    token = @kind.weixin_token
    @validate_data << (token || "")
    @validate_data.sort.join("")
  end

  def validate_nonce
    if params[:signature].blank?
      @current_user ||= session[:user] && User.find_by_id(session[:user]) || :false
    else
      if Digest::SHA1.hexdigest(get_validate_data) == params[:signature]
        unless is_www?
          if xml_data = params[:xml]
#            session[:FromUserName] = xml_data[:FromUserName]
            if self.current_user = User.find_by_weixin_code_and_kindergarten_id(xml_data[:FromUserName],@kind.id)
            else
              session[:user] = nil
              @current_user = :false
            end
          end
        end
      else
        render :text=>"请通过微信访问"
        return
      end
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
