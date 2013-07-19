#encoding:utf-8
#升学策略
class MySchool::CareerStrategiesController < MySchool::ManageController
  def index
    @career_strategies =  @kind.career_strategies.joins("LEFT JOIN squads ON(squads.id = career_strategies.from_id)").order("squads.grade_id,career_strategies.id DESC")
  end

  def new
    @career_strategy = CareerStrategy.new()
    if (@grades = @kind.grades) && !@grades.blank?
      @squads = @grades.first.squads
    end
  end

  def create
    @career_strategy = CareerStrategy.new()
    raise "选择班级不能为空" if params[:from_class_number].blank?
    raise "升学后班级不能为空" if params[:graduation] && params[:from_class_number].blank?
    if from = @kind.squads.find_by_id(params[:from_class_number])
      @career_strategy.from_id = from.id
    else
      raise "选择班级不存在"
    end
    if params[:graduation] == "false"
      if(to = @kind.squads.find_by_id(params[:to_class_number]))
        raise "“选择班级“和“升级后班级“不能一样。" if  @career_strategy.from_id == to.id
        @career_strategy.to_id = to.id
      else
        raise "升学后班级不存在"
      end
    end
    @career_strategy.kindergarten_id = @kind.id
    @career_strategy.add_squad = params[:add_squad] == "true" ? 1 : 0
    @career_strategy.graduation = params[:graduation] == "true" ? 1 : 0
    @career_strategy.save!
    flash[:notice] = "升学策略添加成功."
    redirect_to :action => :show,:id=>@career_strategy.id
  rescue Exception =>ex
    if (@grades = @kind.grades) && !@grades.blank?
      @squads = @grades.first.squads
    end
    flash[:error] = ex.message
    render :action => :new
  end

  
  def edit
    @grades = @kind.grades
    if @career_strategy = CareerStrategy.find_by_id_and_kindergarten_id(params[:id],@kind.id)

      if from_class  = @career_strategy.from
        @from_class  = from_class.id
        if from_class.grade
          @from_grade  = from_class.grade.id
          if !@grades.blank?
            @squads = from_class.grade.squads
          end
        end

      end
      if to_class  = @career_strategy.to
        @to_class  = to_class.id
        if to_class.grade
          @to_grade  = to_class.grade.id
          if !@grades.blank?
            @to_squads = to_class.grade.squads
          end
        end
      end
    else
      raise "查找的升学策略不存在。"
    end
  rescue Exception =>ex
    flash[:error] = ex.message
    render :action => :index
  end

  def update
    if (@grades = @kind.grades) && !@grades.blank?
      @squads = @grades.first.squads
    end
    @career_strategy = CareerStrategy.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    raise "选择班级不能为空。" if params[:from_class_number].blank?
    raise "升学后班级不能为空。" if params[:graduation] && params[:from_class_number].blank?
    if from = @kind.squads.find_by_id(params[:from_class_number])
      @career_strategy.from_id = from.id
    else
      raise "选择班级不存在。"
    end
    if params[:graduation] == "false"
      if(to = @kind.squads.find_by_id(params[:to_class_number]))
        raise "“选择班级“和“升级后班级“不能一样。" if  @career_strategy.from_id == to.id
        @career_strategy.to_id = to.id
      else
        raise "升学后班级不存在"
      end
    end
    @career_strategy.kindergarten_id = @kind.id
    @career_strategy.add_squad = params[:add_squad] == "true" ? 1 : 0
    @career_strategy.graduation = params[:graduation] == "true" ? 1 : 0
    @career_strategy.save!
    flash[:notice] = "升学策略更新成功."
    redirect_to :action => :show,:id=>@career_strategy.id
  rescue Exception =>ex
    if (@grades = @kind.grades) && !@grades.blank?
      @squads = @grades.first.squads
    end
    flash[:error] = ex.message
    render :action => :edit,:id=>params[:id]
  end

  def show
    @career_strategy = CareerStrategy.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def destroy
    @career_strategy = CareerStrategy.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @career_strategy.destroy

    respond_to do |format|
      flash[:notice] = '删除升学策略成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
  
  #多选删除
  def destroy_multiple
    if params[:career_strategy].nil?
      flash[:career_strategy] = "必须选择升学策略"
    else
      params[:career_strategy].each do |career_strategy|
        @kind.career_strategies.destroy(career_strategy)
      end
    end
    respond_to do |format|
      format.html { redirect_to :action=>:index }
    end
  end

  #进行升学
  def career_class
    @kind.transaction do
      message = @kind.career_validate
      unless message.blank?
        flash[:error] = message.sort.join("<br/>")
        redirect_to :action => :index
        return
      end
      message = @kind.career!
    end
    flash[:success] = "升学成功。"
    redirect_to :action => :index
  rescue => e
    flash[:error] = e.message
    redirect_to :action => :index
  end

  #升学验证
  def career_class_validate
    message = @kind.career_validate
    if message.blank?
      flash[:success] = "升学验证通过，可以进行升学操作。"
    else
      flash[:error] = message.sort.join("<br/>")
    end
    redirect_to :action => :index
  end
end
