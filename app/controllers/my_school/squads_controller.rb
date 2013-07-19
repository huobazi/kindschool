#encoding:utf-8
class  MySchool::SquadsController < MySchool::ManageController
  def index
    @squads = @kind.squads.search(params[:squad] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def new
    @squad = Squad.new
    @squad.kindergarten_id = @kind.id
    @squad.historyreview = Time.now.year.to_s + "届"
  end

  def create
    @squad = Squad.new(params[:squad])
    @squad.kindergarten_id = @kind.id
    if @squad.save!
      redirect_to my_school_squad_path(@squad), :notice => "操作成功"
    else
      flash[:error] = "操作失败"
      redirect_to my_school_squads_path
    end
  rescue
    render :action=>'new'
  end

  def edit
    @squad = Squad.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def destroy
    @squad = Squad.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @squad.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end

  def show
    @squad = Squad.find_by_id_and_kindergarten_id(params[:id], @kind.id)
  end

  def update
    @squad = Squad.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @squad.update_attributes(params[:squad])
        #TODO:添加事务
        @squad.source_career_strategies.each do |career_strategy|
          career_strategy.update_attributes(:to_grade_id=>@squad.grade_id,:squad_name=>@squad.name)
        end
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@squad.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @squad.errors, :status => :unprocessable_entity }
      end
    end
  rescue
    render :action=>'edit'
  end

  def destroy_multiple
    if params[:squad].nil?
      flash[:notice] = "必须先选择班级"
    else
      params[:squad].each do |squad|
        if squad.student_infos.any?
          next
        end
        @kind.squads.destroy(squad)
      end
    end
    respond_to do |format|
      format.html { redirect_to my_school_squads_path }
      format.json { head :no_content }
    end
  end

  def add_strategy_view
    @squad = @kind.squads.find_by_id(params[:id])
    @career_strategy = CareerStrategy.new
    @career_strategy.kindergarten_id = @kind.id
    @career_strategy.from_id = @squad.id
  end

  def add_strategy

    @career_strategy = CareerStrategy.new(params[:career_strategy])

    if params[:career_strategy][:graduation]
      flash[:success] = "该班已毕业"
    end

    if @career_strategy.save!
      flash[:success] += "操作成功"
    else
      flash[:error] += "操作失败"
    end

    redirect_to my_school_squad_path(params[:squad_id])
  end
end

