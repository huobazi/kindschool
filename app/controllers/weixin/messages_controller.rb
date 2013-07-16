#encoding:utf-8
class Weixin::MessagesController < Weixin::ManageController
  def index
    @send_date = [["全部时间",""],["最近3天","1"],["最近7天","2"]]
    if params[:messages] && (send_date = params[:messages].delete(:send_date))
      if send_date == "1"
        start_time = Date.today - 3.day
        params[:messages][:send_date_greater_than] = start_time
      elsif send_date == "2"
        start_time = Date.today - 7.day
        params[:messages][:send_date_greater_than] = start_time
      end
    end
    @messages = Message.search(params[:messages] || {}).where("messages.kindergarten_id=:kind_id and message_entries.receiver_id=:user_id",
      {:kind_id=>@kind.id,:user_id=>current_user.id}).joins("LEFT JOIN message_entries ON(messages.id = message_entries.message_id)").page(params[:page] || 1).per(10).order("messages.send_date DESC")
  end
end
