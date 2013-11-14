#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
  #  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:load_config, :except => [:login] #if action_name != 'login'#:auth,
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
