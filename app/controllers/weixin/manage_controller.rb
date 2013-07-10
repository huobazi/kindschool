#encoding:utf-8
class  Weixin::ManageController < Weixin::BaseController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:check_operates,:choose_role, :except => [:login,:signup,:error_notice] #if action_name != 'login'#:auth,

  private
  def check_operates
     if  user =  current_user
     end
  end

  def choose_role
    @role =current_user.role
  end
end
