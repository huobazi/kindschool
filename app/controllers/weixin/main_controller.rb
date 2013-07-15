#encoding:utf-8
class Weixin::MainController < Weixin::BaseController
  layout proc{ |controller| get_layout }
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
    if params[:code].blank?
      flash[:error] = "微信信息不正确"
      redirect_to :action => :error_messages
      return
    end
    return unless request.post?
    begin
      user = User.authenticate(params[:login], params[:password])
    rescue StandardError => error
      @user_errors = error
    end
  end

  #出错信息
  def error_messages
  
  end
  
  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end
end
