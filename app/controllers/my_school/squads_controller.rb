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
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@squad.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @squad.errors, :status => :unprocessable_entity }
      end
    end
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

  def to_squads
    if grade = @kind.grades.where(:id => params[:grade].to_i).first
      @squads = grade.squads
    end
    if @squads.blank?
      render :text => "还未创建班级"
    else
      render "to_squads", :layout => false
    end
  end

  def add_strategy
    binding.pry
  end
end

