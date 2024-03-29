#encoding:utf-8
#教学计划
class MySchool::TeachingPlansController < MySchool::ManageController
  include TeachingPlansHelper
  
  def index
    if current_user.get_users_ranges[:tp] == :student
      @teaching_plans = @kind.teaching_plans.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).page(params[:page] || 1).per(10)
    elsif current_user.get_users_ranges[:tp] == :teachers  
      @teaching_plans = @kind.teaching_plans.where("squad_id in (select squad_id from teachers where staff_id = ?) or squad_id is NULL", current_user.staff.id).page(params[:page] || 1).per(10)
    else
      # if (session[:operates] || []).include?('my_school/teaching_plans/new')
        @teaching_plans = @kind.teaching_plans.search(params[:teaching_plan] || {}).page(params[:page] || 1).per(10)
      # end
    end
  end

  def new
  	@teaching_plan = @kind.teaching_plans.new()
  
   if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
    elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    else
     if @grades = @kind.grades
        if @squads = @grades.first.squads
        end
     end
   end    
end

  def create
  	@teaching_plan = TeachingPlan.new(params[:teaching_plan])
    @teaching_plan.kindergarten = @kind
    @teaching_plan.creater = current_user
     unless params[:appurtenance].blank?
      (params[:appurtenance] || []).each do |p_appurtenance|
       appurtenance=Appurtenance.new(p_appurtenance)
       appurtenance.file_name = p_appurtenance[:avatar].original_filename if p_appurtenance[:avatar]
       if @teaching_plan.appurtenances.size < 6
         @teaching_plan.appurtenances << appurtenance
       end
      end
    end
    unless params[:class_number].blank?
      if squad = Squad.find(params[:class_number].to_i)#where(:id=>params[:class_number].to_i).first
         @teaching_plan.squad =  squad
      end
    end
    if @teaching_plan.save!
      flash[:success] = "创建教学计划成功"
      redirect_to my_school_teaching_plan_path(@teaching_plan)
      return
    else
      flash[:error] = "创建教学计划不成功"
      render :new
      return
    end
    raise "上传的文件大于6m请重新上传."
    rescue Exception =>ex
      message =[]
      unless @topic.blank?
      (@topic.appurtenances||[]).each do |app|
        unless app.errors.blank?
         str = app.errors.messages[:avatar].join("")
         message << str
        end
      end
    end
      flash[:error] = ex.message
      flash[:error] << message.join(",") unless message.blank?#{}"上传的文件大于6m请重新上传."
      render :new

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

  def edit
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
    @squad = @teaching_plan.squad
     if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to action: :index
      return
     elsif current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
     else
      if @grades = @kind.grades
        if @squads = @grades.first.squads
        end
      end
     end 
   end

   def update
    if current_user.get_users_ranges[:tp] == :student
      @teaching_plan = @kind.teaching_plans.where("squad_id = ? or squad_id is null", current_user.student_info.squad_id).find_by_id(params[:id])
    elsif current_user.get_users_ranges[:tp] == :teachers
      @teaching_plan = @kind.teaching_plans.where("squad_id in (select squad_id from teachers where staff_id = ?) or creater_id = ? or squad_id is NULL", current_user.staff.id, current_user.id).find_by_id(params[:id])
    else
      @teaching_plan = @kind.teaching_plans.find_by_id(params[:id])
    end
    if @teaching_plan.nil?
      flash[:error] = "没有权限更改该教学计划"
      redirect_to :action=> :index
      return
    end
    unless params[:appurtenance].blank?
      (params[:appurtenance] || []).each do |p_appurtenance|
       appurtenance=Appurtenance.new(p_appurtenance)
       appurtenance.file_name = p_appurtenance[:avatar].original_filename if p_appurtenance[:avatar]
       if @teaching_plan.appurtenances.size < 6
         @teaching_plan.appurtenances << appurtenance
       end
      end
    end

    respond_to do |format|
      if @teaching_plan.update_attributes(params[:teaching_plan])
        format.html { redirect_to my_school_teaching_plans_path, notice: '教学计划更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
   end

   def destroy
     unless params[:teaching_plan].blank? 
       @teaching_plans = @kind.teaching_plans.where(:id=>params[:teaching_plan])
     else
       @teaching_plans = @kind.teaching_plans.where(:id=>params[:id])
     end
     if @teaching_plans.blank?
       flash[:error] = "请选择教学计划"
       redirect_to :action => :index
       return
     end

     @teaching_plans.each do |teaching_plan|
       teaching_plan.destroy
     end
     respond_to do |format|
       flash[:success] = "删除成长教学计划"
       format.html { redirect_to my_school_teaching_plans_path }
       format.json { head :no_content }
     end
   end
end
