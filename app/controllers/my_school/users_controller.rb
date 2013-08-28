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
          raise "您需要绑定\"微一园讯通\"微信公共帐号<br/>第一次使用本系统，请点击'<a href=\"#login_course\" id=\"link_course\">激活账号指南</a>'"
        end
        if user.weixin_code.blank?
          raise "您需要绑定幼儿园的公共账号后才能访问<br/>第一次使用本系统，请点击'<a href=\"#login_course\" id=\"link_course\">激活账号指南</a>'"
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
        current_user.approve_module_users.each do |approve|
          approve_module = approve.approve_module
          if approve_module.status == true
            operates_data << "my_school/approves"
            if approve_module.number == "News"
              operates_data << "my_school/approves/news_list"
            elsif approve_module.number == "Activity"
              operates_data << "my_school/approves/activities_list"
            elsif approve_module.number == "Notice"
              operates_data << "my_school/approves/notices_list"
            elsif approve_module.number == "Message"
              operates_data << "my_school/approves/messages_list"
            elsif approve_module.number == "Topic"
              operates_data << "my_school/approves/topics_list"
            end
          end
        end
        operates_data.uniq!
        session[:operates] = operates_data
        flash[:notice] = "登录成功."
        session[:login_error_count] = 0
        redirect_to :action => :index,:controller=>"/my_school/home"
        cookies.delete :login_times
      else
        render :layout=>"colorful_login"
      end
    rescue StandardError => error
      if session[:login_error_count]
        session[:login_error_count] +=1
      else
        session[:login_error_count] = 1
      end
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

  def old_password_validator
    if params[:old_password].present?
      unless current_user.authenticated?(params[:old_password])
        @message = "原来密码输入错误"
      end
    end
    if params[:element].present?
      @element = params[:element]
    end
    render "my_school/staffs/phone_uniqueness_validator.js.erb", :layout => false
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
      can_count = @kind.sms_user_count - @kind.get_send_sms_count
      if can_count > 0
        if user.is_send
          user.update_attributes(:is_send=> false,:chain_delete=>true)
          can_count += 1
        else
          chain_code = @kind.get_chain_code
          user.update_attributes(:is_send=> true,:chain_delete=>false,:chain_code=>chain_code)
          can_count -= 1
          #如果已经存在的编号，将去掉
          chain_users = @kind.users.where(:chain_delete=>true,:chain_code=>chain_code)
          unless chain_users.blank?
            chain_users.each do |chain_user|
              chain_user.update_attributes(:chain_delete=>false,:chain_code=>nil)
            end
          end
        end
        flash[:success] = "设置成功，您还可以设置#{can_count}个用户"
      else
        flash[:error] = "设置失败，超过可设置的用户数量。"
      end
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
      can_count = @kind.sms_user_count - @kind.get_gather_sms_count
      if can_count > 0
        user.update_attribute(:is_receive, !user.is_receive)
        flash[:success] = "设置成功，您还可以设置#{can_count - 1}个用户"
      else
        flash[:error] = "设置失败，超过可设置的用户数量。"
      end
      
    else
      flash[:error] = "需要设置的用户不存在"
    end
    redirect_to :back
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to :back
  end


  #重置密码
  def reset_password
    if user = User.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      data_time = 7.day.ago
      ret_records = user.ret_password_records.where("created_at > ?",data_time)
      if ret_records.size > 2
        flash[:notice] = "7天内，你已经超过三次重置密码！"
      else
        user.ret_password_records << RetPasswordRecord.new
        password = Standard.rand_password
        user.password = password
        if user.save!
          title = "您已经成功重置#{@kind.name}微壹校讯通平台密码."
          if @kind.aliases_url.blank?
            web_address = "http://#{@kind.number}.#{WEBSITE_CONFIG["web_host"]}"
          else
            web_address = @kind.aliases_url
          end
          content = "您的登录名:#{user.login},密码:#{password},登录地址:#{web_address}"
          user.send_system_message!("系统消息","#{title} #{content}",3)
          flash[:notice]="短信发送成功"
        end
      end
    else
      flash[:notice]="该用户不存在"
    end
    #zmanby
    redirect_to :back
  end

  private

  def load_noisy_image
    code_size = rand(3) + 4
    session[:noisy_image] = NoisyImage.new(code_size)
    session[:code] = session[:noisy_image].code
  end
end
