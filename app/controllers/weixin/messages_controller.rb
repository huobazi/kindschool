#encoding:utf-8
class Weixin::MessagesController < Weixin::ManageController
  def index
    @send_date = [["全部时间",""],["最近3天","1"],["最近7天","2"]]
    if send_date = params[:send_date]
      if send_date == "1"
        start_time = Date.today - 3.day
        params[:messages][:send_date_greater_than] = start_time
      elsif send_date == "2"
        start_time = Date.today - 7.day
        params[:messages][:send_date_greater_than] = start_time
      end
    end
    params[:messages] = {} if params[:messages].blank?
    params[:messages][:message_entries_receiver_id_equals] = current_user.id
    @messages = Message.search(params[:messages] || {}).where("messages.approve_status=0 AND messages.kindergarten_id=:kind_id AND messages.status = :status",
      {:kind_id=>@kind.id,:status=>1}).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end
  #发件箱
  def outbox
    @messages = current_user.messages.where(:status => true).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  #发件箱查看
  def outbox_show
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
  
  #草稿箱
  def draft_box
    @messages = current_user.messages.where(:status => false).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  def draft_show
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    render "weixin/messages/outbox_show"
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
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
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
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
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
        flash[:error] = "消息不存在"
        redirect_to :action => :index
        return
      end
      @return_messages = @message.return_messages.where(:sender_id=>current_user.id).page(params[:page] || 1).per(5)
    else
      flash[:error] = "消息不存在"
      redirect_to :action => :index
    end
  end

  def return_message
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
      unless @message.message_entries.find_by_receiver_id(current_user.id)
        flash[:error] = "消息不存在"
        redirect_to :action => :index
        return
      end
      @content = params[:content]
      message = Message.new(:kindergarten_id=>@kind.id,:entry_id=>@message.id,:content=>params[:content],:status=>1,:tp=>0,:sender_id=>current_user.id,:send_date=>Time.now)
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
          format.html { redirect_to(:action=>:outbox_show,:id=>@message.id) }
          format.xml  { head :ok }
        else
          #提交的是存为草稿箱按钮就去草稿箱
          format.html { redirect_to(:action=>:draft_show,:id=>@message.id) }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
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
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
    @message.destroy

    respond_to do |format|
      flash[:notice] = '删除通知成功.'
      format.html { redirect_to(:action=>:index) }
      format.xml  { head :ok }
    end
  end
end
