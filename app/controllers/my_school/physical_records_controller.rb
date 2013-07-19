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
      search = PhysicalRecord.where(["student_infos.squad_id in (?)",squads]).joins("LEFT JOIN student_infos on (student_infos.id = seedling_records.student_info_id)").search(params[:physical_record] || {})
      @physical_records =  search.page(params[:page] || 1).per(10).order("created_at DESC")
    elsif userrole[:tp] == :student
      search = current_user.student_info.physical_records.search(params[:physical_record] || {})
      @physical_records =  search.page(params[:page] || 1).per(10).order("created_at DESC")
    end
  end
   
  def new
    if content_pattern = @kind.content_patterns.where(:number=>'physical_record').first
      @physical_record = @kind.physical_records.new(:content=>content_pattern.content)
    else
      @physical_record = @kind.physical_records.new
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
    respond_to do |format|
      if @physical_record.save
        format.html { redirect_to my_school_physical_records_path, :notice=> '学员体检创建成功.' }
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
        format.html { redirect_to my_school_physical_records_path, notice: '学员体检更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @physical_records = @kind.physical_records.where(:id=>params[:id])
    @physical_records.each do |physical_record|
      physical_record.destroy
    end

    respond_to do |format|
      format.html { redirect_to my_school_physical_records_path }
      format.json { head :no_content }
    end
  end

  def show
    @physical_record = @kind.physical_records.find(params[:id])
  end

  def destroy_multiple
    if params[:physical_record].nil?
      flash[:notice] = "必须先选择体检记录"
    else
      params[:physical_record].each do |physical|
        @kind.physical_records.destroy(physical)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_physical_records_path }
      format.json { head :no_content }
    end
  end

end
