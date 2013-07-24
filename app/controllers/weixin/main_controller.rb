#encoding:utf-8
class Weixin::MainController < Weixin::BaseController
  layout proc{ |controller| get_layout }

  before_filter :login_from_cookie
  before_filter :login_required, :except => [:bind_user,:error_messages,:about,:contact_us]

  #平台首页
  def index
    if @subdomain == "" || @subdomain == "www"
    else
      if kind = Kindergarten.find_by_number(@subdomain)
        #        redirect_to :controller=>"/weixin/main",:action=>"index"
        #        return
      else
        @no_kind = true
      end
    end
  end

  #绑定用户
  def bind_user
    if logged_in?
      flash[:notice] = "您已经绑定微信账户"
      redirect_to :controller => "/weixin/main",:action=>:index
      return
    end
    if session[:weixin_code].blank? && params[:code].blank?
      flash[:error] = "微信信息不正确"
      redirect_to :action => :error_messages
      return
    end
    unless params[:code].blank?
      session[:weixin_code] = params[:code]
    end
    session[:weixin_code] ||= params[:code]
    if wexin_user = User.find_by_weixin_code(session[:weixin_code])
      flash[:notice] = "该微信账号已绑定，请进行登陆."
      redirect_to :action => :login,:controller=>"/weixin/users"
      return
    end
    return unless request.post?
    begin
      user = User.authenticate(params[:login], params[:password])
      unless user.weixin_code.blank? && user.weixin_code != session[:weixin_code]
        flash[:error] = "该账号已绑定了另一个微信账号"
        redirect_to :action => :error_messages
        return
      end
      user.update_attribute(:weixin_code, session[:weixin_code])
      self.current_user = user
      redirect_to :controller => "/weixin/main",:action=>:index
    rescue StandardError => error
      @user_errors = error
    end
  end

  def about
    
  end
  
  def contact_us

  end

  #出错信息
  def error_messages
  
  end

  #老师信息，动态加载
  def get_user_all_teachers
    render :partial=>"modules/colorful/weixin_menu_one_teachers",:layout=>false
  end
  #班级信息，动态加载
  def get_user_all_squads
    @squads = current_user.get_users_squads
    render :partial=>"modules/colorful/weixin_menu_one_squads",:layout=>false
  end
  
  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end
end
