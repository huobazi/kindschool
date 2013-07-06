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
     @seedling = SeedlingRecord.new
   end
end
