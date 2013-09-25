#encoding:utf-8
#学员体检
class MySchool::PhysicalRecordsController < MySchool::ManageController
  def index
  	all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']
    userrole = current_user.get_users_ranges
    if @flag=all_roles.include?(@role)
      search = @kind.physical_records.search(params[:physical_record] || {})
      @physical_records = search.page(params[:page] || 1).per(10).order("created_at DESC")
      # @physical_records = @kind.physical_records.page(params[:page] || 1).per(10).order("created_at DESC")
    elsif userrole[:tp] == :all
      @flag= true
      search = @kind.physical_records.search(params[:physical_record] || {})
      @physical_records = search.page(params[:page] || 1).per(10).order("created_at DESC")
      # @physical_records = @kind.physical_records.page(params[:page] || 1).per(10).order("created_at DESC")
    elsif userrole[:tp] == :teachers
      squads = []
      if userrole[:grades]
        userrole[:grades].each do |grade|
          squads  += grade.squads
        end
        squads += userrole[:squads]
      else
        squads = userrole[:squads]
      end
      # studentinfos =  StudentInfo.where(:squad_id=>squads)
      # studentinfos.each do |stu_info|
      #  @physical_records += stu_info.physical_records
      # end
      # @physical_records = PhysicalRecord.where(["student_infos.squad_id in (?)",squads]).joins("LEFT JOIN student_infos on (student_infos.id = seedling_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
      search = PhysicalRecord.where(["student_infos.squad_id in (?)",squads]).joins("inner JOIN student_infos on (student_infos.id = physical_records.student_info_id)").search(params[:physical_record] || {})
      @physical_records =  search.page(params[:page] || 1).per(10).order("created_at DESC")
    elsif userrole[:tp] == :student
      search = current_user.student_info.physical_records.search(params[:physical_record] || {})
      @physical_records =  search.page(params[:page] || 1).per(10).order("created_at DESC")
    end

    if request.xhr?
      @search_record = "physical_records"
      @search_record_count = @physical_records.total_count
      render "my_school/commons/_search_index.js.erb"
    else
      render "index"
    end

  end

  def new
    if content_pattern = @kind.content_patterns.where(:number=>'physical_record').first
      @physical_record = @kind.physical_records.new(:content=>content_pattern.content)
      @physical_record.creater_id = current_user.id
    else
      @physical_record = @kind.physical_records.new
      @physical_record.creater_id = current_user.id
    end
    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos
      end
    end
  end

  def create
    @physical_record = @kind.physical_records.new(params[:physical_record])
    @physical_record.student_info_id = params[:seedling_record][:student_info_id] unless params[:seedling_record].blank?
    @physical_record.creater_id = current_user.id
    respond_to do |format|
      if @physical_record.save
        format.html { redirect_to my_school_physical_record_path(@physical_record), :success=> '学员体检创建成功.' }
      else
        format.html { render :action=> "new" }
      end
    end
  end

  def edit
    @physical_record = @kind.physical_records.find(params[:id])
    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos
      end
    end
  end

  def update
    @physical_record = @kind.physical_records.find(params[:id])
    @physical_record.student_info_id = params[:seedling_record][:student_info_id] unless params[:seedling_record].blank?
    respond_to do |format|
      if @physical_record.update_attributes(params[:physical_record])
        format.html { redirect_to my_school_physical_record_path(@physical_record), success: '学员体检更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    unless params[:physical_record].blank? 
      @physical_records = @kind.physical_records.where(:id=>params[:physical_record])
    else
      @physical_records = @kind.physical_records.where(:id=>params[:id])
    end
    if @physical_records.blank?
      flash[:error] = "请选择体检记录"
      redirect_to :action => :index
      return
    end
    @physical_records.each do |physical_record|
      physical_record.destroy
    end
    respond_to do |format|
      flash[:success] = "删除体检记录成功"
      format.html { redirect_to my_school_physical_records_path }
      format.json { head :no_content }
    end
  end

  def show
    @physical_record = @kind.physical_records.find(params[:id])
  end

  def grade_class
    if  grade=@kind.grades.where(:id=>params[:grade].to_i).first
      @squads = grade.squads
    end
    render "grade_class", :layout => false
  end

  def class_student
    if grade=@kind.grades.where(:id=>params[:grade].to_i).first
      if squad = grade.squads.where(:id=>params[:class_number].to_i).first
         @student_infos = squad.student_infos
      end
    end
    render "class_student", :layout => false
  end
end
