#encoding:utf-8
class  MySchool::ManageController < MySchool::BaseController
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required,:check_operates,:choose_role,:load_add_credit, :except => [:login,:signup,:error_notice] #if action_name != 'login'#:auth,
  after_filter :auto_write_log

  layout proc{ |controller| get_layout }

  #加载积分消息
  def load_add_credit
    if current_user != :false && @kind.enable_credit
      if controller_path == "my_school/home" && action_name =="index"
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

  protected
  def student_can_not_destroy
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "学员没有权限删除"
      redirect_to :action => :index
      return
    end
  end


  private
  #设置模板
  def get_layout
    session[:layout] ||= load_layout
  end
  
  def check_operates
    if  user =  current_user
      if operate = Operate.where(:controller=>controller_path,:action=>action_name).first#(:conditions => ["controller = ? and action like ?", controller_path, "%[#{action_name}]%"])
        unless  user.operates.collect(&:id).include?(operate.id)
          flash[:notice] = "您没有权限访问"
          redirect_to my_school_home_index_path
        end
      end
    end
    @menu_int = ((1..7).to_a.random)
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

  def choose_role
    @role =current_user.role
  end

end
