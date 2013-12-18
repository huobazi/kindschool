#encoding:utf-8
class  MySchool::StatisticsController < MySchool::ManageController

  include StatisticsHelper

  def growth_record
    if current_user.get_users_ranges[:tp] == :student
      flash[:error] = "没有权限"
      redirect_to my_school_home_path
      return
    else current_user.get_users_ranges[:tp] == :teachers
      @squads = current_user.get_users_ranges[:squads]
    end
    if params[:start_at].present? and params[:end_at].present?
      @growth_records = @kind.growth_records.week_stat(params[:start_at], params[:end_at])
      @home_growth_records = @growth_records.where(tp: 1)
      @garden_growth_records = @growth_records.where(tp: 0)
    else
      @growth_records        = @kind.growth_records.week_stat(Time.now.beginning_of_week, Time.now.end_of_week)
      @home_growth_records   = @growth_records.where(tp: 1)
      @garden_growth_records = @growth_records.where(tp: 0)
    end

   @growth_records_count = @kind.growth_records.count
   @home_growth_records_count = @kind.growth_records.where(tp: 1).count
   @garden_growth_records_count = @kind.growth_records.where(tp: 0).count

   @cur_begginning_of_week = Time.now.beginning_of_week.year.to_s + "-" + Time.now.beginning_of_week.month.to_s + "-" + Time.now.beginning_of_week.day.to_s
   @cur_end_of_week = Time.now.end_of_week.year.to_s + "-" + Time.now.end_of_week.month.to_s + "-" + Time.now.end_of_week.day.to_s

    if request.xhr?
      render "my_school/statistics/growth_record.js.erb"
    else
      render "my_school/statistics/growth_record"
    end

  end

  def kind_stat
    unless current_user.get_users_ranges[:tp] == :all
      flash[:error] = "没有权限"
      redirect_to my_school_home_path
      return
    end
  end

  def virtual_squad
    if request.xhr?
      if params[:virtual_squad_id].present?
        @virtual_squad = @kind.squads.where(tp: 1).find_by_id(params[:virtual_squad_id])
        if params[:flag].presence == "all"
          @all = true
        elsif params[:flag].presence == "from_squad"
          @all = false
        end
        respond_to do |format|
          format.html { render "virtual", :layout => false }
        end
      end
    end
  end

  def message
    unless current_user.get_users_ranges[:tp] == :all
      flash[:error] = "没有权限"
      redirect_to my_school_home_path
      return
    end

    @messages = @kind.messages.search(params[:message] || {}).where("status = 1 and (tp = 0 or tp = 1)").page(params[:page] || 1).per(10).order("created_at DESC")

  end

  #短信进行统计
  def sms_statistics
     # @sms_records = SmsRecord.search(params[:sms_records]).where(:kindergarten_id=>@kind.id,:status=>1).page(params[:page] || 1).per(10).order("created_at DESC")
     #统计短信的全部的数量
     @sms_records = SmsRecord.search(params[:sms_records]).select('sms_records.*, sum(sms_records.sms_count) as sum_count').joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)").group('message_entries.message_id').where(:kindergarten_id=>@kind.id,:status=>1).page(params[:page] || 1).per(10).order("created_at DESC")
     @records = SmsRecord.search(params[:sms_records]).select('sms_records.*, sum(sms_records.sms_count) as sum_count').where(:kindergarten_id=>@kind.id,:status=>1).order("created_at DESC")
     @sms_records_count = @records.first.sum_count.to_i unless @records.blank?
     month = Time.now.strftime("%Y-%m")
     @day="#{month}-01 00:00:00"
     @end_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
     # joins("INNER JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)").
     # joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)")
     # .select('sms_records.* , count(sms_records.id) as sum_count')
     #本月的短信总条数
     # @month_sms_records = SmsRecord.select('sms_records.*, sum(sms_records.sms_count) as sum_count').joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)").group('message_entries.message_id').where(:kindergarten_id=>@kind.id,:status=>1).where(" sms_records.created_at between ? and ? ",@day,@end_time).page(params[:page] || 1).per(10).order("created_at DESC")
     @month_records = @records.where(" sms_records.created_at between ? and ? ",@day,@end_time)
     @month_sms_records = @sms_records.where(" sms_records.created_at between ? and ? ",@day,@end_time)
     @month_sms_records_count = @month_records.first.sum_count.to_i unless @month_records.blank?
  end
  def sms_all_statistics
    @sms_records = SmsRecord.search(params[:sms_record]).select('sms_records.*, sum(sms_records.sms_count) as sum_count').joins("LEFT JOIN  message_entries ON(message_entries.id = sms_records.message_entry_id)").group('message_entries.message_id').where(:kindergarten_id=>@kind.id,:status=>1).page(params[:page] || 1).per(10).order("created_at DESC")
    @records = SmsRecord.search(params[:sms_record]).select('sms_records.*, sum(sms_records.sms_count) as sum_count').where(:kindergarten_id=>@kind.id,:status=>1).order("created_at DESC")
    @sms_records_count = @records.first.sum_count.to_i
  end

  # 老师日常管理统计
  def teacher_stat

    unless params[:start_at].blank? and params[:end_at].blank?
      unless params[:staff_name].blank?
        q = "%#{params[:staff_name]}%"
        @staffs = @kind.staffs.joins("INNER JOIN users as u on u.id = staffs.user_id").where("users.name like ?", q)
      else
        @staffs = @kind.staffs
      end
      @syslogs = SysLog.select("count(1) as syslogcount, sys_logs.url_options, sys_logs.user_id, sys_logs.method").joins("INNER JOIN staffs as st on(sys_logs.user_id = st.user_id)").joins("INNER JOIN users as u on u.id = st.user_id").where("u.kindergarten_id=? and sys_logs.created_at >= ? and sys_logs.created_at <= ?", @kind.id, params[:start_at], params[:end_at] ).group("sys_logs.url_options, sys_logs.user_id").group_by {|syslog| syslog.user_id}
      @start_at = params[:start_at]
      @end_at = params[:end_at]
    else
      unless params[:staff_name].blank?
        q = "%#{params[:staff_name]}%"
        @staffs = @kind.staffs.joins("INNER JOIN users as u on u.id = staffs.user_id").where("users.name like ?", q)
      else
        @staffs = @kind.staffs
      end
      @syslogs = SysLog.select("count(1) as syslogcount, sys_logs.url_options, sys_logs.user_id, sys_logs.method").joins("INNER JOIN staffs as st on(sys_logs.user_id = st.user_id)").joins("INNER JOIN users as u on u.id = st.user_id").where("u.kindergarten_id=?", @kind.id).group("sys_logs.url_options, sys_logs.user_id").group_by {|syslog| syslog.user_id}
    end
    if request.xhr?
      render "my_school/statistics/teacher_stat.js.erb"
    else
      render "my_school/statistics/teacher_stat"
    end
  end

  def albums_stat
    @albums_count = @kind.albums.count
    @staffs       = @kind.staffs
    @squads       = @kind.squads

    @squad_albums = Album.squad_albums(@kind)
    @creater_albums = Album.creater_albums(@kind)
  end

end
