#encoding:utf-8
class  MySchool::GrowthRecordStatsController < MySchool::ManageController

  def index
    @growth_record_count        = @kind.growth_records.count
    @home_growth_record_count   = @kind.growth_records.where(tp: 1).count
    @garden_growth_record_count = @kind.growth_records.where(tp: 0).count

  end

end
