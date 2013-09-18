#encoding:utf-8
class  MySchool::StudentInfosController < MySchool::ManageController

  def index
    str = ""
    unless params[:weixin_bland].blank? 
      if params[:weixin_bland]=="1"
        str = "weixin_code is not null and weixin_code!=''  and weiyi_code is not null and weiyi_code!=''"
      elsif params[:weixin_bland]=="2"
        str = "(weixin_code is null or weixin_code='')  and (weiyi_code is null or weiyi_code='')"
      elsif params[:weixin_bland]=="3"
        str = "weixin_code is not null and weixin_code!='' and (weiyi_code is null or weiyi_code='')"
      elsif params[:weixin_bland]=="4"
        str = "(weixin_code is  null or weixin_code='') and weiyi_code is not null and weiyi_code!=''"
      end
    end
    if current_user.get_users_ranges[:tp] == :student
      @student_infos = @kind.student_infos.where(:id=>current_user.student_info.id).page(params[:page] || 1).per(10)
    elsif current_user.get_users_ranges[:tp] == :teachers  
      @student_infos = @kind.student_infos.where("#{str}").where("squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?)",current_user.staff.id).search(params[:student_info] || {}).page(params[:page] || 1).per(10).order("student_infos.created_at DESC")
    else
      @student_infos = @kind.student_infos.where("#{str}").search(params[:student_info] || {}).page(params[:page] || 1).per(10)
    end
    store_search_location
    if request.xhr?
      @search_record = "student_infos"
      @search_record_count = @student_infos.count
      render "my_school/commons/_search_index.js.erb"
    else
      render "index"
    end
  end

  def download_student_infos
    @student_infos = @kind.student_infos.search(params[:student_info] || {})#.page(params[:page] || 1).per(10)
    respond_to do |format|
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end
 
  

  def import
    unless params[:file].blank?
      x,a,b,c=StudentInfo.verification_import(params[:file],@kind.id)
      if x.blank? && a.blank? && b.blank? && c.blank?
        StudentInfo.import(params[:file],@kind.id)
        redirect_to my_school_student_infos_path(:importing=>1,:add_node=>params[:add_node]), :notice=> "学生信息导入成功."
        return
      else
        redirect_to my_school_student_infos_path(:importing=>1,:add_node=>params[:add_node]), :notice=> "#{x.join(',')}手机号或班级名字不能为空,#{a.join(',')}系统已经存在电话号码不能添加,#{b.join(',')}班级不存在,#{c.join(',')}手机号码重复"
        return
      end
    else
      redirect_to my_school_student_infos_path(:importing=>1,:add_node=>params[:add_node]), :notice=> "没有选择导入表格."
      return
    end
    raise "导入模板出问题，请与管理员联系."
  rescue Exception =>ex
    flash[:error] = ex.message
    redirect_to my_school_student_infos_path(:importing=>1,:add_node=>params[:add_node]), :notice=> "导入模板出问题，请与管理员联系."

  end



  def show
    if current_user.tp == 0
      @student_info = StudentInfo.find_by_user_id_and_kindergarten_id(current_user.id, @kind.id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      @student_info = @kind.student_infos.where("squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?)",current_user.staff.id).find_by_id(params[:id])
    else
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      @user_squads = @student_info.user.user_squads 
      @virtual_squads = @kind.squads.where(:tp=>1)
    end

    if @student_info.nil?
      flash[:error] = "没有权限或学员不存在"
      redirect_to :action => :index
    end
  end

  def virtual_squad
    @virtual_squads = @kind.squads.where(:tp=>1)
    render :layout => false
  end

  def virtual_squad_choose
    @virtual_squads= {}
    unless current_user.tp == 0
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      unless params["virtual_squad_ids"].blank?
        virtual_squad_ids = params["virtual_squad_ids"].split(',')
        @virtual_squads=@kind.squads.where(:id=>virtual_squad_ids,:tp=>1)
        (@student_info.user.user_squads || []).each do |squad|
          squad.destroy
        end
        @virtual_squads.each do |v_squad|
          user_squad = UserSquad.new(:user_id=>@student_info.user.id,:squad_id=>v_squad.id)
          user_squad.save
        end
      end
    end
    render :json => @virtual_squads,:layout=>false
  end

  def new
    @student_info = StudentInfo.new
    @student_info.kindergarten = @kind
    @student_info.user = User.new(:kindergarten_id => @kind.id, :tp => 0)
    if current_user.get_users_ranges[:tp] == :all
      @grades = @kind.grades
    end

    if current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    end

  end

  def create
    @student_info = StudentInfo.new(params[:student_info])
    params[:student_info][:user_attributes][:phone].gsub!(/\s*$/, '')  if params[:student_info] && params[:student_info][:user_attributes]
    @student_info.kindergarten_id = @kind.id
    begin
      if @student_info.save!
        if params[:asset_logo] && (user = @student_info.user)
          user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
          user.save
        end
        redirect_to my_school_student_info_path(@student_info), :notice => "添加学员成功"
      end
    rescue Exception
      render "new"
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      if current_user.student_info.id != params[:id].to_i
        flash[:notice] = "不能编辑他人的信息"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      else
        @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
        if @student_info.nil?
          flash[:error] = "没有权限或非法操作"
          redirect_to :back
          return
        end
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      if (@student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)) && current_user.staff.squads.include?(@student_info.squad)
        @squads = current_user.staff.squads
        @squad_id = @student_info.squad_id
      else
        flash[:notice] = "没有权限"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      end
    else current_user.get_users_ranges[:tp] == :all
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      if @student_info.nil?
        flash[:error] = "没有权限或非法操作"
        redirect_to :back
        return
      end
      @grades = @kind.grades
      @grade_id = @student_info.squad.try(:grade_id)
    end
  end

  def update
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    params[:student_info][:user_attributes][:phone].gsub!(/\s*$/, '')  if params[:student_info] && params[:student_info][:user_attributes]
    if current_user.get_users_ranges[:tp] == :student
      if current_user.student_info.id != params[:id].to_i
        flash[:notice] = "不能编辑他人的信息"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
        return
      end
      params[:student_info].except(:squad_id)
    elsif current_user.get_users_ranges[:tp] == :teachers
      if (@student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)) && current_user.staff.squads.include?(@student_info.squad)
      else
        flash[:notice] = "没有权限"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      end
    end


    begin
      if @student_info.update_attributes!(params[:student_info])
        if params[:asset_logo] && (user = @student_info.user)
          user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
          user.save
        end
        flash[:notice] = '更新学员成功.'
        redirect_to :action => :show, :id => @student_info.id
      end
    rescue Exception=>ex
      flash[:error] = ex.message
      render :edit
    end
  end

  def destroy
    unless params[:student].blank? 
      @student_infos = @kind.student_infos.where(:id=>params[:student])
    else
      @student_infos = @kind.student_infos.where(:id=>params[:id])
    end
    if @student_infos.blank?
      flash[:error] = "请选择学员"
      redirect_to :action => :index
    end
    @student_infos.each do |student_info|
      if user = student_info.user
        user.destroy
      end
    end
    respond_to do |format|
      flash[:success] = "删除学员成功"
      format.html { redirect_to my_school_student_infos_path }
      format.json { head :no_content }
    end
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
      if params[:has_default_squad].present?
        @has_default_squad = params[:has_default_squad].to_i
      end
    end
    render "grade_squad", :layout => false
  end

  def student_execl
    @student_info = @kind.student_infos.find(params[:student_info_id])  
    @user = @student_info.user
    exel = render_to_string(:layout=>'print')
    send_data exel, :content_type => "application/excel", :filename => "#{@user.name}_信息下载.xls"
  end

  def phone_uniqueness_validator
    if params[:phone].present? and params[:element].present?
      if params[:student_info_id].present?
        phones = User.where("id != ?", params[:student_info_id]).select(:phone).collect(&:phone)
      else
        phones = User.pluck(:phone)
      end
      if phones.include?(params[:phone])
        @message = "手机号被占用"
      end
      if params[:element].present?
        @element = params[:element]
      end
      render "phone_uniqueness_validator.js.erb", :layout => false
    end
  end
end
