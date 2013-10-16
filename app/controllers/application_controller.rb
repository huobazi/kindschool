#encoding:utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :school_install?
  before_filter :set_p3p

  before_filter :load_auth_code
  def load_auth_code
    if controller_path == "active_admin/devise/sessions" && action_name=="create"
      if params[:auth_code] != session[:code]
        flash[:error] = "验证码不正确"
        redirect_to :action => "new",:controller=>"/active_admin/devise/sessions"
      end
    end
  end

  # check_authorization
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end
  def current_ability
    @current_ability ||= AdminAbility.new(current_admin_user)
  end
  def access_denied(exception)
    redirect_to admin_dashboard_path, :alert => exception.message
  end
  
  def set_p3p
    headers['P3P'] = "policyref=\"/w3c/p3p.xml\", CP=\"ALL DSP COR CURa ADMa DEVa TAIa OUR BUS IND UNI COM NAV INT\""
  end 

  private
  def school_install?
    @subdomain =request.subdomain
    url_domain = request.domain
    if url_domain != "localhost.com" && WEBSITE_CONFIG["web_host"] != url_domain
      @aliases_url = url_domain
    end
  end

end
