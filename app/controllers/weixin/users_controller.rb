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
        redirect_to :action => :index,:controller=>"/weixin/main"
        cookies.delete :login_times
      end
    rescue StandardError => error
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
end
