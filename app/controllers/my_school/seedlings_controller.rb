#encoding:utf-8
#学员育苗
class MySchool::SeedlingsController < MySchool::ManageController
   def index 
   	 all_roles = ['admin','principal','vice_principal','assistant_principal','park_hospital']
   	 userrole = current_user.get_users_ranges
   	 if all_roles.include?(@role)
   	    @seedlings = @kind.seedling_records
     elsif userrole[:tp] == :all
        @seedlings = @kind.seedling_records
     elsif userrole[:tp] == :teachers
        @seedlings = []
        squads = []
        if userrole[:grades]
          userrole[:grades].each do |grade|
            squads  += grade.squads
          end
          squads += userrole[:squads]
          else 
            squads = userrole[:squads]
        end
          studentinfos =  StudentInfo.where(:squad_id=>squads)
          studentinfos.each do |stu_info|
           @seedlings += stu_info.seedling_records
          end  
     elsif userrole[:tp] == :student
     	  @seedlings =  current_user.student_info.seedling_records
   	 end
   end

   def new
     @seedling = @kind.seedling_records.new
     if @grades = @kind.grades
        if @squads = @grades.first.squads
          @student_infos = @squads.first.student_infos 
        end
     end
   end
   
   def create
    @seedling = @kind.seedling_records.new(params[:seedling_record])
     respond_to do |format|
      if @seedling.save
        format.html { redirect_to my_school_seedlings_path, notice=> 'Push tag was successfully created.' }
      else
        format.html { render :action=> "new" }
      end
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
