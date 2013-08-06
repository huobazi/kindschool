#encoding:utf-8
class  MySchool::StudentInfosController < MySchool::ManageController

  def index
    if current_user.tp == 0
      @student_infos = @kind.student_infos.where(:id=>current_user.id).page(params[:page] || 1).per(10)
    else
      @student_infos = @kind.student_infos.search(params[:student_info] || {}).page(params[:page] || 1).per(10)
    end
    respond_to do |format|
      format.html
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  def show
    if current_user.tp == 0
      @student_info = StudentInfo.find_by_user_id_and_kindergarten_id(current_user.id, @kind.id)
    else
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      @user_squads = @student_info.user.user_squads
      @virtual_squads = @kind.squads.where(:tp=>1)
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
    @grades = @kind.grades
  end

  def create
    @student_info = StudentInfo.new(params[:student_info])
    @student_info.kindergarten_id = @kind.id
    if @student_info.save!
      if params[:asset_logo] && (user = @student_info.user)
        if user.asset_logo
          user.asset_logo.update_attribute(:uploaded_data, params[:asset_logo])
        else
          user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
          user.save
        end
      end
      redirect_to my_school_student_info_path(@student_info), :notice => "添加学员成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_student_infos_path
    end
  end

  def edit
    if current_user.get_users_ranges[:tp] == :student
      if current_user.student_info.id != params[:id].to_i
        flash[:notice] = "不能编辑他人的信息"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      else
        @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      if (@student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)) && current_user.staff.squads.include?(@student_info.squad)
      else
        flash[:notice] = "没有权限"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      end
    else current_user.get_users_ranges[:tp] == :all
      @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    end
  end

  def update
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    if current_user.get_users_ranges[:tp] == :student
      if current_user.student_info.id != params[:id].to_i
        flash[:notice] = "不能编辑他人的信息"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      end
    elsif current_user.get_users_ranges[:tp] == :teachers
      if (@student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)) && current_user.staff.squads.include?(@student_info.squad)
      else
        flash[:notice] = "没有权限"
        redirect_to :controller => "/my_school/users", :action => :show, :id => current_user.id
      end
    end

    
    respond_to do |format|
      if @student_info.update_attributes(params[:student_info])
        if params[:asset_logo] && (user = @student_info.user)
          if user.asset_logo
            user.asset_logo.update_attribute(:uploaded_data, params[:asset_logo])
          else
            user.asset_logo = AssetLogo.new(:uploaded_data=> params[:asset_logo])
            user.save
          end
        end
        flash[:notice] = '更新学员成功.'
        format.html { redirect_to(:action=>:show,:id=>@student_info.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @student_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @student_info = StudentInfo.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    @student_info.destroy

    respond_to do |format|
      flash[:notice] = '删除学员成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end

  def destroy_multiple
    if params[:student].nil?
      flash[:notice] = "必须先选择学员"
    else
      params[:student].each do |student|
        @kind.student_infos.destroy(student)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_student_infos_path }
      format.json { head :no_content }
    end
  end

  def grade_squad_partial
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_squad", :layout => false
  end

  def student_execl
    @student_info = @kind.student_infos.find(params[:student_info_id])  
    @user = @student_info.user
    exel = render_to_string(:layout=>'print')
    send_data exel, :content_type => "application/excel", :filename => "#{@user.name}_信息下载.xls"
  end
end
