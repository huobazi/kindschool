#encoding:utf-8
class  MySchool::TeachersController < MySchool::ManageController

  def allocation
    unless @staff = Staff.find_by_id(params[:id])
      flash[:notice] = "没有该教职工"
      redirect_to :action => :index, :controller => "/my_school/staffs"
      return
    end
  end

  def update_allocation
    if @staff = Staff.find_by_id(params[:staff_id])
      ids = params[:squad] || []
      #delete
      if ids.blank?
        @staff.teachers.each do |teacher|
          teacher.destroy
        end
      else
        @staff.teachers.each do |teacher|
          unless ids.include?(teacher.squad_id.to_s)
            teacher.destroy
          end
        end
      end
      #add
      ids.each do |squad_id|
        unless Teacher.find_by_squad_id_and_staff_id(squad_id,@staff.id)
          Teacher.create(:squad_id=>squad_id,:staff_id => @staff.id)
        end
      end

      flash[:success] = "操作成功"
      redirect_to :action => :show, :controller => "/my_school/staffs",:id=>@staff.id
    else
      flash[:error] = "教职工不存在"
      redirect_to :action => :index, :controller => "/my_school/staffs"
    end
  end

  def set_class_teacher
    if (@teacher = Teacher.find_by_id(params[:teacher_id])) && @teacher.tp == 0
      if @squad = @kind.squads.find_by_id(params[:squad_id])
        @un_class_teacher = @squad.teachers
        @un_class_teacher.update_all(:tp => 0)
      end
      if @teacher.update_attributes(:tp => 1)
        flash[:success] = "操作成功"
        redirect_to :controller => "/my_school/staffs", :action => :show, :id => params[:staff_id]
      else
        flash[:error] = "操作失败"
        redirect_to :controller => "/my_school/staffs", :action => :show, :id => params[:staff_id]
      end
    else
      flash[:error] = "不能为将该负责人设置为班主任"
      redirect_to :controller => "/my_school/staffs", :action => :show, :id => params[:staff_id]
    end
  end

end
