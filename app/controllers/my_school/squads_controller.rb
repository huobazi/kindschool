#encoding:utf-8
class  MySchool::SquadsController < MySchool::ManageController
  def index
    @squads = @kind.squads.where(tp: 0).search(params[:squad] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
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
    @squad = Squad.where(tp: 0).find_by_id_and_kindergarten_id(params[:id],@kind.id)
    if @squad.nil?
      flash[:error] = "没有权限或非法操作"
      redirect_to :action => :index
    end
  end

  def destroy
    puts "11111111111\n\n\n"
    puts params[:squad].inspect
    unless params[:squad].blank?
      @squads = @kind.messages.where(:id=>params[:squad])
    else
      @squads = @kind.messages.where(:id=>params[:id])
      puts @squads.inspect
    end

  Squad.transaction do
    begin
      @squads.each do |squad|
        student_infos = squad.student_infos
         unless student_infos.blank?
          puts "1111111111\n\n\n\n"
          raise "该班级有学员" 
          else
          puts "222222222\n\n\n\n"
           squad.destroy 
         end
      end
    end
  end
    # respond_to do |format|
    #   flash[:notice] = '删除班级成功.'
    #   format.html { redirect_to(:action=>:index) }
    #   format.xml  { head :ok }
    # end
  end

  def show
    @squad = Squad.where(tp: 0).find_by_id_and_kindergarten_id(params[:id], @kind.id)
    @data = current_user.get_users_ranges
    if @squad.nil?
      flash[:error] = "没有权限或非法操作"
      redirect_to :action => :index
    end
  end

  def update
    params[:squad][:kindergarten_id] = @kind.id if params[:squad]
    @squad = Squad.where(tp: 0).find_by_id_and_kindergarten_id(params[:id],@kind.id)
    if @squad.nil?
      flash[:error] = "没有权限或非法操作"
      redirect_to :action => :index
    end
    respond_to do |format|
      if @squad.update_attributes(params[:squad])
        #TODO:添加事务
        @squad.source_career_strategies.each do |career_strategy|
          career_strategy.update_attributes(:to_grade_id=>@squad.grade_id,:squad_name=>@squad.name)
        end unless @squad.graduate
        flash[:notice] = '修改班级成功.'
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

  def set_squads_teacher
    users = User.where(:id=>params[:ids])
    @squad = Squad.where(tp: 0).find_by_id_and_kindergarten_id(params[:id], @kind.id)
    users.each do |user|
      Teacher.find_or_create_by_squad_id_and_staff_id(@squad.id,user.staff.id)
    end
    render :layout=>false
  end
  def cancel_class_teacher
    @squad = Squad.where(tp: 0).find_by_id_and_kindergarten_id(params[:id], @kind.id)
    if teacher = @squad.teachers.where(:staff_id=>params[:staff_id]).first
      flash[:notice] = "取消成功"
      teacher.destroy
    else
      flash[:notice] = "非法操作"
    end
  redirect_to :action =>:show, :id => params[:id]
  end

end

