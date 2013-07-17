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
    @message = Message.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
end