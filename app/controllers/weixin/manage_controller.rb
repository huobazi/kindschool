#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
  #  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:load_config,:load_add_credit, :except => [:login] #if action_name != 'login'#:auth,
  after_filter :auto_write_log
  layout proc{ |controller| get_layout }
  private

  def load_config
    @role =current_user.role
    if WEBSITE_CONFIG["weixin_blind"]
      if current_user.weiyi_code.blank?
        flash[:error] = "您还未绑定\"微一园讯通\"平台公共账号,请关注微信公共账号\"微一园讯通\",并进行绑定。"
        redirect_to :action => :error_messages,:controller=>"/weixin/main"
        return
      end
    end
    if session[:operates].blank?
      operates_data = current_user.operates.collect{ |operate| "#{operate.controller}/#{operate.action}"}
      operates_data.uniq!
      session[:operates] = operates_data
    end
  end

  #加载积分消息
  def load_add_credit
    if current_user != :false && @kind.enable_credit
      if controller_path == "weixin/main" && action_name =="index"
        #登陆加分效果
        today_login,add_login_credit = current_user.config[:today_login],true
        if !today_login.blank? && Time.now.to_date.to_s == today_login
          add_login_credit = false
        end
        if add_login_credit
          credit = current_user.save_user_credit("login",0)
          unless credit.blank?
            @add_credit = credit
            current_user.config[:today_login] = Time.now.to_date.to_s
          end
        end
      end
    end
  end
  

  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end

  ##自动添加日志 (根据日志配置过滤)
  def auto_write_log
    if current_user != :false
      if  user =  current_user
        SysLog.write_log user.id, url_options[:_path_segments], request.method,
          request.original_url,request.remote_ip,params,@kind.id #if Rails.env.production?
      end
    end
  end

end
