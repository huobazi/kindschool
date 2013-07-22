#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
  #  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:load_config, :except => [:login] #if action_name != 'login'#:auth,
  layout proc{ |controller| get_layout }
  private

  def load_config
    @role =current_user.role
  end
  private
  #设置模板
  def get_layout
    session[:weixin_layout] ||= "#{load_layout}_weixin"
  end
end
