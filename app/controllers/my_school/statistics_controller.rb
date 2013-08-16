#encoding:utf-8
class  MySchool::StatisticsController < MySchool::ManageController

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

  end

  def kind_stat

  end

  def message
    unless current_user.get_users_ranges[:tp] == :all
      flash[:error] = "没有权限"
      redirect_to my_school_home_path
      return
    end

    @messages = @kind.messages.search(params[:message] || {}).where("status = 1 and (tp = 0 or tp = 1)").page(params[:page] || 1).per(10).order("created_at DESC")

  end

end

