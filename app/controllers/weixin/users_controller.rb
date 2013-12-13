#encoding:utf-8
class Weixin::UsersController < Weixin::ManageController
  
  protect_from_forgery :except=>:signup

  #登录
  def login
    if logged_in?
      redirect_to :action => :index,:controller=>"/weixin/main"
      return
    end
    return render :layout=>false unless request.post?
    begin
      if request.post?
        if session[:login_error_count]  && session[:login_error_count] > 2
          @can_auth = true
        
          if params[:auth_code].blank?
            load_noisy_image
            raise "请填写验证码"
          end
          if params[:auth_code] != session[:noisy_image].code
            raise "验证码不正确"
          else
            load_noisy_image
          end
        end
      else
        if session[:login_error_count]  && session[:login_error_count] > 2
          load_noisy_image
          @can_auth = true
        end
        return render :layout=>"colorful_login"
      end
      user = User.authenticate(params[:login], params[:password],@kind.id)
      if WEBSITE_CONFIG["weixin_blind"]
        if user.weiyi_code.blank?
          raise  "您需要绑定\"微一园讯通\"微信公共帐号"
        end
        if user.weixin_code.blank?
          raise "您需要绑定幼儿园的公共账号后才能访问"
        end
      end
      self.current_user = user
      
      if logged_in?
        if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token ,
            :expires => self.current_user.remember_token_expires_at }
        end
        operates_data = self.current_user.operates.collect{ |operate| "#{operate.controller}/#{operate.action}"}
        operates_data.uniq!
        session[:operates] = operates_data
        flash[:notice] = "登录成功."
        session[:login_error_count] = 0
        #这个地方加登录添加积分
        user.save_user_credit("login",0)
        redirect_to :action => :index,:controller=>"/weixin/main"
        cookies.delete :login_times
      end
    rescue StandardError => error
      if session[:login_error_count]
        session[:login_error_count] +=1
      else
        session[:login_error_count] = 1
      end
      @user_errors = error
      render :layout=>false
    end
  end

  #登出
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    #flash[:notice] = "You have been logged out."
    redirect_to :action => "login"
    #    redirect_back_or_default(root_path)
  end


  def change_password_view
    @user = User.find_by_id(current_user.id)
  end

  def change_password
    if params[:user]
      if params[:user][:password].blank?
        flash[:error] = "密码不能为空"
        raise "密码不能为空"
      end
      if params[:user][:password] != params[:user][:password_confirmation]
        flash[:error] = "密码不一致"
        raise "密码不一致"
      end
    else
      flash[:error] = "请输入密码"
      raise "请输入密码"
    end
    if current_user.update_attributes(:password=>params[:user][:password],:password_confirmation=>params[:user][:password_confirmation])
      flash[:success] = "更新密码成功"
      redirect_to :controller => "/weixin/main", :action => :index
    else
      flash[:error] = "更新密码失败"
      redirect_to :controller => "/weixin/users", :action => :change_password_view
    end
  rescue Exception =>ex
    flash[:error] = ex.message if flash[:error].blank?
    redirect_to :controller => "/weixin/users", :action => :change_password_view
  end

  def edit
    @user = User.find_by_id(current_user.id)
    @user.kindergarten_id = @kind.id
    @user.tp = current_user.tp
  end

  def update
    @user = User.find_by_id(current_user.id)
    if @user.update_attributes(params[:user])
      if params[:asset_logo]
        @user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
        @user.save
      end
      flash[:success] = "修改用户个人信息成功"
      redirect_to weixin_path(@user)
    else
      flash[:error] = "操作失败"
      render :edit
    end
  end

  private

  def load_noisy_image
    code_size = rand(3) + 4
    session[:noisy_image] = NoisyImage.new(code_size)
    session[:code] = session[:noisy_image].code
  end
end
