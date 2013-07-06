#encoding:utf-8
class MySchool::MessagesController < MySchool::ManageController
  #列表界面
  def index
    @message = Message.where("messages.kindergarten_id=:kind_id and message_entries.receiver_id=:user_id",
      {:kind_id=>@kind.id,:user_id=>current_user.id}).joins("LEFT JOIN message_entries ON(messages.id = message_entries.message_id)").page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  def new
    @message = Message.new
    @data = current_user.get_users_ranges
  end
  
  def edit
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
  def destroy
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @notice.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
  def show
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def create
    @notice = Notice.new(params[:notice])
    @notice.kindergarten = @kind
    @notice.creater = current_user
    respond_to do |format|
      if @notice.save
        flash[:notice] = '提交通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@notice.id) }
        format.xml  { render :xml => @notice, :status => :created, :location => @notice }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @notice.update_attributes(params[:notice])
        flash[:notice] = '更新通知成功.'
        format.html { redirect_to(:action=>:show,:id=>@notice.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @notice.errors, :status => :unprocessable_entity }
      end
    end
  end
  #获取全部学生
  def get_student
    data = current_user.get_users_ranges
    if data[:tp] == :all
      @data = @kind.users.where(:tp=>0,:status=>"start").group_by(&:tp)
      render :partial => "users",:layout=>false
    else
      render :text=>"获取全部学生"
    end
  end
  #获取全院
  def get_kindergarten
    data = current_user.get_users_ranges
    if data[:tp] == :all
      @data = @kind.users.where(:status=>"start").group_by(&:tp)
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全院"
    end
  end
  #获取全教职工
  def get_grade
    data = current_user.get_users_ranges
    if data[:tp] == :all
      @data = @kind.users.where(:tp=>1,:status=>"start").group_by(&:tp)
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全教职工"
    end
  end

  #选取了年级的学生
  def get_grades_all
    data = current_user.get_users_ranges
    if data[:tp] == :all
      @data = @kind.users.where(:tp=>0,
        :status=>"start",
        "squads.grade_id"=>params[:ids].collect{|obj| obj.to_i}).joins("LEFT JOIN student_infos ON(users.id = student_infos.user_id) \
LEFT JOIN squads ON(squads.id = student_infos.squad_id) \
LEFT JOIN grades ON(grades.id = squads.grade_id) ").group_by(&:tp)
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全教职工"
    end
  end

end
