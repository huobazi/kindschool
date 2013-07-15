#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
#  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:choose_role, :except => [:login] #if action_name != 'login'#:auth,

  private

  def choose_role
    @role =current_user.role
  end
end
