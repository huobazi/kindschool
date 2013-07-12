#encoding:utf-8
class MySchool::UsersController < MySchool::ManageController

  before_filter :correct_user, :only => [:edit]

  
  protect_from_forgery :except=>:signup
  #提示界面
  def index

  end
  def error_notice
    
  end
  #登录
  def login
    if logged_in?
      redirect_to :action => :index,:controller=>"/my_school/home"
      return
    end
    return render :layout=>"colorful_login" unless request.post?
    begin
      self.current_user = User.authenticate(params[:login], params[:password])
      if logged_in?
        if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token ,
            :expires => self.current_user.remember_token_expires_at }
        end
        operates_data = self.current_user.operates.collect{ |operate| "#{operate.controller}/#{operate.action}"}
        operates_data.uniq!
        session[:operates] = operates_data
        flash[:notice] = "登陆成功."
        redirect_to :action => :index,:controller=>"/my_school/home"
        cookies.delete :login_times
      else
        render :layout=>"colorful_login"
      end
    rescue StandardError => error
      @user_errors = error
      render :layout=>"colorful_login"
    end
  end

  def edit
    @user = User.find_by_id(current_user.id)
  end

  def change_password_view
    @user = User.find_by_id(current_user.id)
  end

  def change_password
    if params[:old_password] && current_user.authenticated?(params[:old_password])
      if current_user.update_attributes(params[:user])
        flash[:success] = "更新密码成功"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      else
        flash[:notice] = "操作失败"
        redirect_to :controller => "/my_school/users", :action => :change_password_view
      end
    else
      flash[:error] = "原始密码不正确"
      redirect_to :controller => "/my_school/users", :action => :change_password_view
    end


  end

  #  #新建用户
  #  def signup
  #    if logged_in?
  #    else
  #      if params[:code].blank?
  #        redirect_to :action => "error_notice"
  #        return
  #      end
  #      @user = User.new(params[:user])
  #      @user.weixin_code = params[:code] if params[:code]
  #      return unless request.post?
  #      @user.save!
  #      self.current_user = @user
  #      flash[:notice] = "创建用户成功"
  #    end
  ##    redirect_back_or_default(:action=>'index',:vote_type=>params[:vote_type])
  #    redirect_to :action => "random_in",:controller=>"/weixin/random_votes",:vote_type=>params[:vote_type]
  #  rescue ActiveRecord::RecordInvalid
  #    render :action => 'signup'
  #  end

  #登出
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    #flash[:notice] = "You have been logged out."
    redirect_to :action => "login"
    #    redirect_back_or_default(root_path)
  end

end
