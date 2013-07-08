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
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
  def destroy
    @message = NotMessageice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @message.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
  def show
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def create
    @message = Message.new(params[:message])
    @message.kindergarten = @kind
    @message.sender = current_user
    if params[:ids].blank?
      flash[:error]="收件人不能为空"
      render :action => "new"
      return
    end
    sender_ids = current_user.get_sender_users(params[:ids])
    sender_ids.each do |user_id|
      if user = User.find_by_id_and_kindergarten_id(user_id,@kind.id)
        @message.message_entries << MessageEntry.new(:receiver_id=>user.id,:receiver_name=>user.name,:sms=>user.phone)
      end
    end
    respond_to do |format|
      if @message.save
        flash[:notice] = '提交信息成功.'
        format.html { redirect_to(:action=>:show,:id=>@message.id) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = '更新消息成功.'
        format.html { redirect_to(:action=>:show,:id=>@message.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
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

  #选取了年级
  #如果传params[:contain_teachers]=="1"表示获取包含老师
  def get_grades_all
    data = current_user.get_users_ranges
    if data[:tp] == :all || data[:tp] == :teachers
      @data,users_data,ids = {},[],[]
      if data[:tp] == :teachers
        if !data[:grades].blank? && !params[:ids].blank?
          ids  = data[:grades].collect{|grade| grade.id.to_s} & (params[:ids])
        end
      else
        ids = params[:ids]
      end
      unless ids.blank?
        users = @kind.users.where(:tp=>0,
          :status=>"start",
          "squads.grade_id"=>ids.collect{|obj| obj.to_i}).joins("LEFT JOIN student_infos ON(users.id = student_infos.user_id) \
LEFT JOIN squads ON(squads.id = student_infos.squad_id) \
LEFT JOIN grades ON(grades.id = squads.grade_id) ")
        if users.any?
          users_data += users
        end
        if params[:contain_teachers]=="1"
          #年级组长
          grade_teachers = []
          @kind.grade_teachers.where("grades.id"=>ids).each do |staff|
            grade_teachers << staff.user if staff.user && staff.user.status=="start"
          end
        
          if grade_teachers.any?
            users_data += grade_teachers
          end
          teachers = []
          @kind.squads_teachers.where("squads.grade_id"=>params[:ids],"squads.graduate"=>false).each do |teacher|
            teachers << teacher.staff.user if teacher.staff && teacher.staff.user && teacher.staff.user.status=="start"
          end
          if teachers.any?
            users_data += teachers
          end
        end
        users_data.uniq!
        @data = users_data.group_by(&:tp)
      end
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全教职工"
    end
  end
  #选取了班级
  #如果传params[:contain_teachers]=="1"表示获取包含老师
  def get_squads_all
    data = current_user.get_users_ranges
    if data[:tp] == :all || data[:tp] == :teachers
      @data,users_data,ids = {},[],[]
      if data[:tp] == :teachers
        if !data[:squads].blank? && !params[:ids].blank?
          ids  = data[:squads].collect{|squad| squad.id.to_s} & (params[:ids])
        end
      else
        ids = params[:ids]
      end
      unless ids.blank?
        users = @kind.users.where(:tp=>0,
          :status=>"start",
          "squads.graduate"=>false,
          "squads.id"=>ids).joins("LEFT JOIN student_infos ON(users.id = student_infos.user_id) \
LEFT JOIN squads ON(squads.id = student_infos.squad_id)")
        if users.any?
          users_data += users
        end
        
        if params[:contain_teachers]=="1"
          teachers = []
          @kind.squads_teachers.where("squads.id"=>params[:ids],"squads.graduate"=>false).each do |teacher|
            teachers << teacher.staff.user if teacher.staff && teacher.staff.user && teacher.staff.user.status=="start"
          end
          if teachers.any?
            users_data += teachers
          end
        end
        users_data.uniq!
        @data = users_data.group_by(&:tp)
      end
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全教职工"
    end
  end
  #选取了角色
  def get_roles_all
    data = current_user.get_users_ranges
    if data[:tp] == :all || data[:tp] == :teachers
      @data,users_data = {},[]
      unless params[:ids].blank?
        
        users = @kind.users.where(:tp=>1,:status=>"start",:role_id=>params[:ids])
        if users.any?
          users_data += users
        end
        users_data.uniq!
        @data = users_data.group_by(&:tp)
      end
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择全教职工"
    end
  end
  
  #选取个人用户
  def get_users_all
    data = current_user.get_users_ranges
    if data[:tp] == :all || data[:tp] == :teachers
      @data,users_data,ids = {},[],[]
      if data[:tp] == :teachers
        squads = data[:squads]
        unless data[:grades].blank?
          data[:grades].each do |grade|
            squads = grade.squads | squads
          end
        end
        users_ids = []
        squads.each do |squad|
          users_ids += squad.users.collect{|user| user.id.to_s}
        end
        users_ids += @kind.users.where(:status=>"start",:tp=>1).collect{|user| user.id.to_s}
        users_ids.uniq
        
        if !users_ids.blank? && !params[:ids].blank?
          ids  = users_ids & (params[:ids])
        end
      else
        ids = params[:ids]
      end
      unless ids.blank?
        users = @kind.users.where(:status=>"start",:id=>ids)
        if users.any?
          users_data += users
        end
        users_data.uniq!
        @data = users_data.group_by(&:tp)
      end
      render :partial => "users",:layout=>false
    elsif data[:tp] == :student
      @data,users_data,ids = {},[],[]

      squad = data[:squad]
      if squad.grade && squad.grade.staff && (user = squad.grade.staff.user)
        ids << user.id.to_s
      end
      ids = squad.staffs.collect{|staff| staff.user ? staff.user.id.to_s : "0"} | ids
      ids = ids & (params[:ids]) if !params[:ids].blank?
      ids.uniq!
      unless ids.blank?
        users = @kind.users.where(:status=>"start",:id=>ids)
        if users.any?
          users_data += users
        end
        users_data.uniq!
        @data = users_data.group_by(&:tp)
      end
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法选择操作"
    end
  end
end
