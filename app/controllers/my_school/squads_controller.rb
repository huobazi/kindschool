#encoding:utf-8
class  MySchool::SquadsController < MySchool::ManageController
  def index
    @squads = @kind.squads.page(params[:page] || 1).per(10).order("created_at DESC")
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
end

