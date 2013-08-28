#encoding:utf-8
class  MySchool::StaffsController < MySchool::ManageController
  def index
    @staffs = @kind.staffs.search(params[:staff] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def show
    @staff = Staff.find_by_id(params[:id])
  end

  def new
    @staff = Staff.new
    @staff.user = User.new(:kindergarten_id => @kind.id, :tp => 1)
    @role_teacher = @kind.roles.where(:name=>"老师").first
  end

  def create
    @staff = Staff.new(params[:staff])
    params[:staff][:user_attributes][:phone].gsub!(/\s*$/, '')  if params[:staff] && params[:staff][:user_attributes]
    if params[:role] && params[:role][:id]
      role = @kind.roles.find(params[:role][:id])
      unless role.blank?
        @staff.user.role = role
      end
    end
    begin
      if @staff.save!
        if params[:asset_logo] && (user = @staff.user)
          if user.asset_logo
            user.asset_logo.update_attribute(:uploaded_data, params[:asset_logo])
          else
            user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
            user.save
          end
        end
        redirect_to my_school_staff_path(@staff), :notice => "操作成功"
      end
    rescue Exception =>ex
      flash[:error] = ex.message
      render :action => "new"
    end
  end

  def edit
    @staff = Staff.find_by_id(params[:id])
  end

  def update
    @staff = Staff.find_by_id(params[:id])
    if params[:role] && params[:role][:id]
      role = @kind.roles.find(params[:role][:id])
      unless role.blank?
        @staff.user.role = role
      end
    end
    params[:staff][:user_attributes][:phone].gsub!(/\s*$/, '')  if params[:staff] && params[:staff][:user_attributes]
    begin
     if  @staff.update_attributes!(params[:staff]) && @staff.save!
      if params[:asset_logo] && (user = @staff.user)
        if user.asset_logo
          user.asset_logo.update_attribute(:uploaded_data, params[:asset_logo])
        else
          user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
          user.save
        end
      end
      flash[:notice] = '修改教职工成功.'
      redirect_to(:action=>:show,:id=>@staff.id)
     end
    rescue Exception =>ex
      flash[:error] = ex.message
      render :action => :edit
    end
  end

  def destroy
    unless params[:staff].blank? 
      @staffs = @kind.staffs.where(:id=>params[:staff])
    else
      @staffs = @kind.staffs.where(:id=>params[:id])
    end
    if @staffs.blank?
      flash[:error] = "请选择教职工"
      redirect_to :action => :index
      return
    end
    @staffs.each do |staff|
      if user = staff.user
        user.destroy
      end
    end
    respond_to do |format|
      flash[:success] = "删除教职工成功"
      format.html { redirect_to my_school_staffs_path }
      format.json { head :no_content }
    end
  end

  def phone_uniqueness_validator
    if params[:phone].present? and params[:element].present?
      phones = User.pluck(:phone)
      if phones.include?(params[:phone])
        @message = "手机号被占用"
      end
      if params[:element].present?
        @element = params[:element]
      end
      render "phone_uniqueness_validator.js.erb", :layout => false
    end
  end

  def login_uniqueness_validator
    if params[:login].present? and params[:element].present?
      logins = User.pluck(:login)
      if logins.include?(params[:login])
        @message = "用户名被占用"
      end
      if params[:element].present?
        @element = params[:element]
      end
      render "login_uniqueness_validator.js.erb", :layout => false
    end
  end

end
