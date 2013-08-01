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
      if session[:login_error_count]  && session[:login_error_count] > 2
        @can_auth = true
        if request.post?
          if params[:auth_code].blank?
            load_noisy_image
            raise "请填写验证码"
          end
          if params[:auth_code] != session[:noisy_image].code
            raise "验证码不正确"
          else
            load_noisy_image
          end
        else
          load_noisy_image
          return render :layout=>"colorful_login"
        end
      end
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
        session[:login_error_count] = 0
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
  private

  def load_noisy_image
    code_size = rand(3) + 4
    session[:noisy_image] = NoisyImage.new(code_size)
    session[:code] = session[:noisy_image].code
  end
end
