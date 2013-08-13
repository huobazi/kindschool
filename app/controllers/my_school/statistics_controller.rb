#encoding:utf-8
class  MySchool::StatisticsController < MySchool::ManageController

  def growth_record
    if params[:start_at].present? and params[:end_at].present?
      @growth_records = @kind.growth_records.where("start_at >= ? and end_at <= ?", params[:start_at], params[:end_at])
      @home_growth_record_count = @growth_records.where(tp: 1).count
      @garden_growth_record_count = @growth_records.where(tp: 0).count
    else
      @growth_record_count        = @kind.growth_records.count
      @home_growth_record_count   = @kind.growth_records.where(tp: 1).count
      @garden_growth_record_count = @kind.growth_records.where(tp: 0).count
    end

  end

end

