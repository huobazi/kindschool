#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
  #  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:load_config, :except => [:login] #if action_name != 'login'#:auth,
  layout proc{ |controller| get_layout }
  private

  def load_config
    @role =current_user.role
    if current_user.weiyi_code.blank?
      flash[:error] = "您还未绑定\"微一园讯通\"平台公共账号,请关注微信公共账号\"微一园讯通\",并进行绑定。"
      redirect_to :action => :error_messages,:controller=>"/weixin/main"
      return
    end
  end
  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end
end
