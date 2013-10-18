#encoding:utf-8
#教学计划
class Weixin::TeachingPlansController < Weixin::ManageController
  def index
    if current_user.get_users_ranges[:tp] == :student
      @teaching_plans = @kind.teaching_plans.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1).per(6)
    elsif current_user.get_users_ranges[:tp] == :teachers  
      @teaching_plans = @kind.teaching_plans.where("squad_id in (select squad_id from teachers where staff_id = ?) or squad_id is NULL", current_user.staff.id).page(params[:page] || 1).per(6)
    else
      if (session[:operates] || []).include?('my_school/teaching_plans/new')
        @teaching_plans = @kind.teaching_plans.page(params[:page] || 1).per(6)
      end
    end
    AccessStatu.update_unread(@kind, "TeachingPlan", current_user)
  end

  def show
     if current_user.get_users_ranges[:tp] == :student
      @teaching_plan = @kind.teaching_plans.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @teaching_plan = @kind.teaching_plans.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @teaching_plan = @kind.teaching_plans.find_by_id(params[:id])
    end
    if @teaching_plan.nil?
      flash[:error] = "没有权限查看该教学计划"
      redirect_to :action=> :index
      return
    end
  end

end
