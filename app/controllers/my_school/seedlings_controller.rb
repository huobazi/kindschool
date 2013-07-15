#encoding:utf-8
#学员育苗
class MySchool::SeedlingsController < MySchool::ManageController
   def index 
   	 all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']
   	 userrole = current_user.get_users_ranges
   	 if @flag=all_roles.include?(@role)
   	    @seedlings = @kind.seedling_records.page(params[:page] || 1).per(10).order("created_at DESC")
     elsif userrole[:tp] == :all
        @seedlings = @kind.seedling_records.page(params[:page] || 1).per(10).order("created_at DESC")
        @flag = true
     elsif userrole[:tp] == :teachers
        # @seedlings = []
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
          #  @seedlings += stu_info.seedling_records
          # end 
         @seedlings =SeedlingRecord.where(["student_infos.squad_id in(?)",squads]).joins("LEFT JOIN student_infos on (student_infos.id = seedling_records.student_info_id)").page(params[:page] || 1).per(10).order("created_at DESC")
     elsif userrole[:tp] == :student
     	  @seedlings =  current_user.student_info.seedling_records.page(params[:page] || 1).per(10).order("created_at DESC")
   	 end
   end

   def new
     @seedling = @kind.seedling_records.new
     if (@grades = @kind.grades) && !@grades.blank?
        if (@squads = @grades.first.squads) && !@squads.blank?
          @student_infos = @squads.first.student_infos 
        end
     end
   end
   
   def create
    @seedling = @kind.seedling_records.new(params[:seedling_record])
     respond_to do |format|
      if @seedling.save
        format.html { redirect_to my_school_seedlings_path, notice: '学员的育苗创建成功.' }
      else
        format.html { render :action=> "new" }
      end
    end
   end

   def edit
     @seedling = @kind.seedling_records.find(params[:id])
     if (@grades = @kind.grades) && !@grades.blank?
        if (@squads = @grades.first.squads) && !@squads.blank?
          @student_infos = @squads.first.student_infos 
        end
     end
   end

   def show
    @seedling = @kind.seedling_records.find(params[:id])
   end

   def update
    @seedling = @kind.seedling_records.find(params[:id])
    respond_to do |format|
      if @seedling.update_attributes(params[:seedling_record])
        format.html { redirect_to my_school_seedlings_path, notice: '学员育苗更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
  end
   
  def destroy
    @seedlings = @kind.seedling_records.where(:id=>params[:id])
    @seedlings.each do |seedling|
     seedling.destroy
     end

    respond_to do |format|
      format.html { redirect_to my_school_seedlings_path }
      format.json { head :no_content }
    end
  end

  def destory_choose
    
    @seedlings = @kind.seedling_records.where(:id=>params[:id])
    @seedlings.each do |seedling|
     seedling.destroy
     end

    respond_to do |format|
      format.html { redirect_to my_school_seedlings_path }
      format.json { head :no_content }
    end
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
