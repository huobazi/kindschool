#encoding:utf-8
class MySchool::UsersController < MySchool::ManageController


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
    @user.kindergarten_id = @kind.id
    @user.tp = current_user.tp
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      if params[:asset_logo]
        if @user.asset_logo
          @user.asset_logo.update_attribute(:uploaded_data, params[:asset_logo])
        else
          @user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
          @user.save
        end
      end
      flash[:success] = "修改用户个人信息成功"
      redirect_to my_school_user_path(@user)
    else
      flash[:error] = "操作失败"
      render :edit
    end
  end

  def show
    @user = current_user
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

  #设置能发送短信
  def set_send_sms
    if user = User.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      user.update_attribute(:is_send, !user.is_send)
      flash[:success] = "设置成功。"
    else
      flash[:error] = "需要设置的用户不存在"
    end
    redirect_to :back
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to :back
  end

  #设置能收到短信
  def set_gather_sms
    if user = User.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      user.update_attribute(:is_receive, !user.is_receive)
      flash[:success] = "设置成功。"
    else
      flash[:error] = "需要设置的用户不存在"
    end
    redirect_to :back
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to :back
  end
end
