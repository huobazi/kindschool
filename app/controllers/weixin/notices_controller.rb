#encoding:utf-8
class Weixin::NoticesController < Weixin::ManageController
  #列表界面
  def index
    @send_date = [["全部时间",""],["最近3天","1"],["最近7天","2"]]
    if send_date = params[:send_date]
      if send_date == "1"
        start_time = Date.today - 3.day
        params[:notices][:send_date_greater_than] = start_time
      elsif send_date == "2"
        start_time = Date.today - 7.day
        params[:notices][:send_date_greater_than] = start_time
      end
    end
    params[:notices] = {} if params[:notices].blank?
    userrole = current_user.get_users_ranges
    unless userrole.blank?
      if  userrole[:tp] == :all
        send_range = [0,1,2]
        @notices = @kind.notices.search(params[:notices] || {}).where(:send_range=>send_range).page(params[:page] || 1).per(10).order("send_date DESC")
      elsif userrole[:tp] == :teachers
        # 如果是老师能够查看到所有的全教职工和全园的信息
        send_range = [0,1]
        @notices = @kind.notices.search(params[:notices] || {}).where("send_date < ? or creater_id= ?" ,Time.zone.now,current_user.id).where(:send_range=>send_range).page(params[:page] || 1).per(10).order("send_date DESC")
      elsif userrole[:tp] == :student
        send_range = [0,2]
        @notices = @kind.notices.search(params[:notices] || {}).where("send_date < ?" ,Time.zone.now).where(:send_range=>send_range).page(params[:page] || 1).per(10).order("send_date DESC")
      end
    end
  end
  def show
    @notice = Notice.find_by_id_and_kindergarten_id(params[:id],@kind.id)
  end
end
