#encoding:utf-8
class  MySchool::ManageController < MySchool::BaseController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:check_operates,:choose_role, :except => [:login,:signup,:error_notice] #if action_name != 'login'#:auth,

  layout proc{ |controller| get_layout }
  private
  #设置模板
  def get_layout
    session[:layout] ||= load_layout
  end
  
  def check_operates
     if  user =  current_user
      if operate = Operate.where(:controller=>controller_path,:action=>action_name).first#(:conditions => ["controller = ? and action like ?", controller_path, "%[#{action_name}]%"])   
       unless  user.operates.include?(operate)
         flash[:notice] = ""
         redirect_to my_school_home_index_path
       end
     end
     end
  end

  def choose_role
    @role =current_user.role
  end

end
