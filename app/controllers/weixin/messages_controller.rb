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
    @messages = Message.search(params[:messages] || {}).where("messages.kindergarten_id=:kind_id AND messages.status = :status",
      {:kind_id=>@kind.id,:status=>1}).page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end

  def show
    if @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
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
end