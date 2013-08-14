#encoding:utf-8
class  MySchool::StatisticsController < MySchool::ManageController

  def growth_record
    if params[:start_at].present? and params[:end_at].present?
      @growth_records = @kind.growth_records.where("start_at >= ? and end_at <= ?", params[:start_at], params[:end_at])
      @home_growth_record_count = @growth_records.where(tp: 1).count
      @garden_growth_record_count = @growth_records.where(tp: 0).count
    else
      @growth_records        = @kind.growth_records.where("start_at >= ? and end_at <= ?", Time.now.beginning_of_week, Time.now.end_of_week)
      @home_growth_record_count   = @kind.growth_records.where(tp: 1).count
      @garden_growth_record_count = @kind.growth_records.where(tp: 0).count
    end

   @growth_records_count = @kind.growth_records.count
   @home_growth_records_count = @kind.growth_records.where(tp: 1).count
   @garden_growth_records_count = @kind.growth_records.where(tp: 0).count

   @cur_begginning_of_week = Time.now.beginning_of_week.year.to_s + "-" + Time.now.beginning_of_week.month.to_s + "-" + Time.now.beginning_of_week.day.to_s
   @cur_end_of_week = Time.now.end_of_week.year.to_s + "-" + Time.now.end_of_week.month.to_s + "-" + Time.now.end_of_week.day.to_s

  end

  def kind_stat
    @grades_count = @kind.grades.count
    @squads_count = @kind.squads.count
    @student_infos_count = @kind.student_infos.count
  end

end

