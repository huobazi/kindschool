#encoding:utf-8
class Weixin::MainController < Weixin::BaseController
  layout proc{ |controller| get_layout }
  include Weixin::WeixinStatusHelper

  before_filter :login_from_cookie
  before_filter :login_required, :except => [:bind_user,:error_messages,:about,:contact_us,:bind_weiyi,:weiyi_error_messages]

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
  #官网出错信息
  def weiyi_error_messages
    @logo_url =  @kind && @kind.asset_img ? @kind.asset_img.public_filename : '/t/colorful/logo.png'
    render :layout=>"colorful_weixin_weiyi"
  end
  #微壹平台绑定
  def bind_weiyi
    # params[:code]
    #1、判断这个code，在你新加的字段里存不存在
    #2、如果不存在，着显示绑定界面
    #3、如果存在，就提示您已绑定成功，通过幼儿园的公共账号访问
    #4、不存在时，绑定的动作post的请求，绑定到code的字段里去，需要验证用户名密码
    #5、User 的authenticate取另外一个名字，验证密码时不加幼儿园id
    if @required_type == :www
      if request.get?
        if params[:code].blank?
          flash[:error] = "数据不准确，请返回微信，点击“账号绑定”重新操作."
          redirect_to :action => :weiyi_error_messages
          return
        end
        user = User.find_by_weiyi_code(params[:code])
        unless user.blank?
          # render :text=> "该微信账号已绑定微壹平台微信公共帐号，通过幼儿园的公共账号访问."
          flash[:error] = "该微信账号已绑定微壹平台微信公共帐号，通过幼儿园的公共账号访问."
          redirect_to :action => :weiyi_error_messages
          return
        end
        session[:weiyi_code] = params[:code]
        render :layout=>"colorful_weixin_weiyi"
        return
      else
        begin
          if session[:weiyi_code].blank?
            flash[:error] = "数据不准确，请返回微信，点击“账号绑定”重新操作."
            redirect_to :action => :weiyi_error_messages
            return
          end
          user = User.authenticate_weiyi(params[:login], params[:password])
          if !user.weiyi_code.blank? && user.weiyi_code != session[:weiyi_code]
            flash[:error] = "该账户已绑定了另一个微信账号"
            redirect_to :action => :weiyi_error_messages
            return
          end
          user.update_attribute(:weiyi_code,(session[:weiyi_code]))
          # render :text=> "该微信账号已绑定，通过幼儿园的公共账号访问."
          flash[:success] = "该微信账户绑定成功，请通过幼儿园的公共账号访问."
          redirect_to :action => :weiyi_error_messages
        rescue StandardError => error
          @user_errors = error
          render :layout=>"colorful_weixin_weiyi"
          return
        end
      end
    else
      flash[:error] = "您需要关注\"微一园讯通\"微信公共帐户."
      redirect_to :action => :weiyi_error_messages
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
      flash[:notice] = "该微信账户已绑定，请进行登录."
      redirect_to :action => :login,:controller=>"/weixin/users"
      return
    end
    return unless request.post?
    begin
      user = User.authenticate(params[:login], params[:password],@kind.id)
      unless user.weixin_code.blank? && user.weixin_code != session[:weixin_code]
        flash[:error] = "该账户已绑定了另一个微信账户"
        redirect_to :action => :error_messages
        return
      end
      user.update_attribute(:weixin_code, session[:weixin_code])
      if user.weiyi_code.blank?
        flash[:success] = "幼儿园公共账户绑定成功，您还需要绑定微信公共账户\"微一园讯通\""
        redirect_to :action=>:error_messages
      else
        flash[:success] = "幼儿园公共账户绑定成功"
        self.current_user = user
        redirect_to :controller => "/weixin/main",:action=>:index
      end
      
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
    @logo_url =  @kind && @kind.asset_img ? @kind.asset_img.public_filename : '/t/colorful/logo.png'
  end

  #老师信息，动态加载
  def get_user_all_teachers
    render :partial=>"modules/colorful/weixin_menu_one_teachers",:layout=>false
  end
  #班级信息，动态加载
  def get_user_all_squads
    @squads = current_user.get_users_ranges[:squads]
    render :partial=>"modules/colorful/weixin_menu_one_squads",:layout=>false
  end
  
  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end
end
