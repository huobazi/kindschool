#encoding:utf-8
class MySchool::MessagesController < MySchool::ManageController
  #列表界面
  def index
    params[:messages] = {} if params[:messages].blank?
    params[:messages][:message_entries_receiver_id_equals] = current_user.id
    @message = Message.search(params[:messages] || {}).where("messages.approve_status=0 AND messages.kindergarten_id=:kind_id and `message_entries`.receiver_id=:user_id AND `message_entries`.`deleted_at` IS NULL",
      {:kind_id=>@kind.id,:user_id=>current_user.id}).select("message_entries.read_status,messages.*").page(params[:page] || 1).per(10).order("messages.send_date DESC")

    if request.xhr?
      @search_record = "message"
      @search_record_count = @message.total_count
      render "my_school/commons/_search_index.js.erb"
    else
      render "index"
    end
  end
  
  #发件箱
  def outbox
    @messages = current_user.messages.where(:status => true).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  def new
    @message = Message.new
    @data = current_user.get_users_ranges
    if params[:message_id]
      if message = Message.find_by_id_and_kindergarten_id(params[:message_id],@kind.id)
        if entry = message.message_entries.where(:receiver_id=>current_user.id)
          @receiver_id = message.sender_id
          @message.tp = 1
        end
      end
    end
  end

  def edit
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      # entry = @message.message_entries.where(:receiver_id=>current_user.id)
      # if entry.blank?
      if @message.sender != current_user
        flash[:error] = '您无法修改该消息.'
        redirect_to(:action=>:index)
        return
      end
    end
  end

  def destroy
    unless params[:message].blank?
      @messages = @kind.messages.where(:id=>params[:message])
    else
      @messages = @kind.messages.where(:id=>params[:id])
    end
    
    if params[:tp] && params[:tp] == "receiver"
      @messages.each do |message|
        if entry_data = message.message_entries.where(:receiver_id=>current_user.id)
          entry_data.each do |entry|
            entry.destroy
          end
        end
      end
    else
      @messages.each do |message|
        message.destroy
      end
    end

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html {
        if params[:tp]
          if params[:tp] == "receiver"
            redirect_to(:action=>:index)
          else
            redirect_to(:action=>:outbox)
          end
        else
          redirect_to(:action=>:draft_box)
        end
      }
      format.xml  { head :ok }
    end
  end
  
  def show
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      if @message.approve_status != 0
        flash[:error] = '您无法查看该消息。'
        redirect_to(:action=>:index)
        return
      end
      if entry = @message.message_entries.find_by_receiver_id(current_user.id)
        if !entry.read_status
          entry.update_attribute(:read_status, true)
        end
      else
        flash[:error] = '您无法查看该消息。'
        redirect_to(:action=>:index)
        return
      end
    else
      flash[:error] = '消息不存在。'
      redirect_to(:action=>:index)
      return
    end
  end
  #查看消息的阅读情况
  def get_entry_status
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      @entries = @message.message_entries.joins(:receiver).select("message_entries.id,read_status,users.name,users.tp")
      render :partial => "entry_status",:layout=>false
    else
      render :text=>"消息不存在。"
    end
  end

  def outbox_show
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end

  def create
    if params[:message]
      tp_data = params[:message].delete(:tp)
      params[:message][:tp] = tp_data.blank? ? 0 : 1
      send_me = params[:message].delete(:send_me)
      params[:message][:send_me] = send_me.blank? ? false : true
    end
    @message = Message.new(params[:message])
    @message.kindergarten = @kind
    @message.send_date = Time.now.utc
    @message.sender = current_user
    if params[:commit] == "发送消息"
      @flag =true
      if params[:ids].blank?
        flash[:error]="收件人不能为空"
        render :action => "new"
        return
      end
    end
    sender_ids = current_user.get_sender_users(params[:ids])
    sender_ids.each do |user_id|
      if user = User.find_by_id_and_kindergarten_id(user_id,@kind.id)
        @message.message_entries << MessageEntry.new(:receiver_id=>user.id,:receiver_name=>user.name,:phone=>user.phone,:sms=>(user.is_receive ? 1 : 0))
      end
    end
    if @message.send_me && !sender_ids.include?(current_user.id.to_s)
      @message.message_entries << MessageEntry.new(:receiver_id=>current_user.id,:receiver_name=>current_user.name,:phone=>current_user.phone,:sms=>(current_user.is_receive ? 1 : 0))
    end
    if params[:draft]
      @message.status = 0
    else
      @message.status = 1
    end
    respond_to do |format|
      if @message.save
        flash[:notice] = '提交信息成功.'
        #提交的是发送消息按钮就去发件箱
        if @flag == true
          format.html { redirect_to({:action=>:outbox_show,:id=>@message.id,:clear_cookie=>1}) }
          format.xml  { head :ok }
        else
          #提交的是存为草稿箱按钮就去草稿箱
          format.html { redirect_to(:action=>:draft_show,:id=>@message.id,:clear_cookie=>1) }
        end
      else
        format.html { render :action => "new"}
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  rescue Exception=>ex
    render :action => "new"
  end

  def update
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    respond_to do |format|
      if params[:message]
        tp_data = params[:message].delete(:tp)
        params[:message][:tp] = tp_data.blank? ? 0 : 1
        send_me = params[:message].delete(:send_me)
        params[:message][:send_me] = send_me.blank? ? false : true
      end
      if @message.update_attributes(params[:message])
        flash[:notice] = '更新消息成功.'
        format.html { redirect_to(:action=>:outbox_show,:id=>@message.id) }
        format.xml  { head :ok }
      else
        @data = current_user.get_users_ranges
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
        if !params[:ids].blank?
          squad_ids = []
          if !data[:squads].blank?
            squad_ids  += data[:squads].collect{|squad| squad.id.to_s}
          end
          if !data[:playgroup].blank?
            squad_ids  += data[:playgroup].collect{|user_squad| user_squad.squad_id.to_s}
          end
          if !data[:grades].blank?
            data[:grades].each{|grade| squad_ids  += grade.squads.collect{|squad| squad.id.to_s}}
          end
          squad_ids.uniq!
          ids  = squad_ids & (params[:ids])
        end
      else
        ids = params[:ids]
      end
      unless ids.blank?
        
        users = @kind.users.where(:tp=>0,
          :status=>"start",
          "squads.tp"=>0,
          "squads.graduate"=>false,
          "squads.id"=>ids).joins("LEFT JOIN student_infos ON(users.id = student_infos.user_id) \
LEFT JOIN squads ON(squads.id = student_infos.squad_id)")
        if users.any?
          users_data += users
        end


        play_users = User.where(:tp=>(params[:contain_teachers]=="1" ? [0,1] : 0),
          :status=>"start",
          "squads.tp"=> 1,
          "squads.graduate"=>false,
          "squads.id"=>ids).joins("LEFT JOIN user_squads ON(users.id = user_squads.user_id) \
LEFT JOIN squads ON(squads.id = user_squads.squad_id)")
        if play_users.any?
          users_data += play_users
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
  #
  def get_edit_ids
    if message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      users_data = message.message_entries.collect{|entry| entry.receiver}
      @data = users_data.group_by(&:tp)
      render :partial => "users",:layout=>false
    else
      render :text=>"您无法修改该信息"
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
          if params[:receiver_id]
            ids = [params[:receiver_id]]
          else
            ids  = users_ids & (params[:ids])
          end
        end
      else
        if params[:receiver_id]
          ids = [params[:receiver_id]]
        else
          ids = params[:ids]
        end
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
      unless data[:playgroup].blank?
        data[:playgroup].each do |user_squad|
          ids += user_squad.get_teachers.collect{|user| user.id.to_s}
        end
      end
      if params[:receiver_id]
        ids = [params[:receiver_id]]
      else
        ids = squad.staffs.collect{|staff| staff.user ? staff.user.id.to_s : "0"} | ids
        ids = ids & (params[:ids]) if !params[:ids].blank?
      end
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

  def destroy_multiple
    if params[:message].nil?
      flash[:notice] = "必须选择消息"
    else
      params[:message].each do |message|
        @kind.messages.destroy(message)
      end
      flash[:success] = "删除成功"
    end
    respond_to do |format|
      format.html { redirect_to my_school_messages_path }
      format.json { head :no_content }
    end
  end

  def draft_box
    @messages = current_user.messages.where(:status => false).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  def draft_show
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    render "my_school/messages/outbox_show"
  end

  def draft_edit
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @data = current_user.get_users_ranges
  end

  def draft_update
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    
    if params[:commit] == "发送消息"
      @flag =true
      if params[:message].blank?
        params[:message][:status] = 1
      else
        params[:message][:status] = 1
      end
      if params[:ids].blank?
        flash[:notice] = "收件人不能为空"
        redirect_to :controller=>'my_school/messages' ,:action=>:draft_edit,:id=>@message.id,:noctie=>@notice
        return
      end
    end
    (@message.message_entries || []).each do |m_e|
      m_e.destroy
    end
    sender_ids = current_user.get_sender_users(params[:ids])
    sender_ids.each do |user_id|
      if user = User.find_by_id_and_kindergarten_id(user_id,@kind.id)
        @message.message_entries << MessageEntry.new(:receiver_id=>user.id,:receiver_name=>user.name,:phone=>user.phone,:sms=>(user.is_receive ? 1 : 0))
      end
    end
    if @message.send_me && !sender_ids.include?(current_user.id.to_s)
      @message.message_entries << MessageEntry.new(:receiver_id=>current_user.id,:receiver_name=>current_user.name,:phone=>current_user.phone,:sms=>(current_user.is_receive ? 1 : 0))
    end
    if params[:send]
      params[:message].merge(:send_date => Time.now.utc)
    end
    respond_to do |format|
      if params[:message]
        tp_data = params[:message].delete(:tp)
        params[:message][:tp] = tp_data.blank? ? 0 : 1
        send_me = params[:message].delete(:send_me)
        params[:message][:send_me] = send_me.blank? ? false : true
      end
      if @message.save && @message.update_attributes(params[:message])
        flash[:notice] = '更新消息成功.'
        if @message.status == true
          format.html { redirect_to(:action=>:outbox_show,:id=>@message.id) }
          format.xml  { head :ok }
        else
          format.html { redirect_to(:action=>:draft_show,:id=>@message.id) }
          format.xml  { head :ok }
        end
      else
        @data = current_user.get_users_ranges
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def return_message
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      unless @message.message_entries.find_by_receiver_id(current_user.id)
        flash[:error] = "消息不存在"
        redirect_to :action => :index
        return
      end
      @content = params[:message][:content] if params[:message]
      message = Message.new(:kindergarten_id=>@kind.id,:entry_id=>@message.id,:content=>@content,:status=>1,:tp=>0,:sender_id=>current_user.id,:send_date=>Time.now)
      message.message_entries << MessageEntry.new(:receiver_id=>@message.sender_id)
      message.save!
      flash[:notice] = "回复成功"
      redirect_to :action => :show,:id=>@message.id
    else
      flash[:error] = "消息不存在"
      redirect_to :action => :index
    end
  rescue Exception=>ex
    flash[:error] = ex.message
    redirect_to :action => :show,:id=>@message.id
  end
end
