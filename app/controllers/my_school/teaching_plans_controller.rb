#encoding:utf-8
#教学计划
class MySchool::TeachingPlansController < MySchool::ManageController
  
  def index
  	@teaching_plans = TeachingPlan.page(params[:page] || 1).per(10)
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
    @teaching_plan = @kind.teaching_plans.find(params[:id])
  end

  def edit
    @teaching_plan = @kind.teaching_plans.find(params[:id])
    @squad = @teaching_plan.squad
     if @grades = @kind.grades
        if @squads = @grades.first.squads
        end
    end
   end

   def update
    @teaching_plan = @kind.teaching_plans.find(params[:id])

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
     @teaching_plan = @kind.teaching_plans.find(params[:id])
      @teaching_plan.destroy
       flash[:notice] = '删除成功.'
       respond_to do |format|
         format.html { redirect_to my_school_teaching_plans_path }
         format.json { head :no_content }
       end 
   end
end
