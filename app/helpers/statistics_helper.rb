#encoding:utf-8
module StatisticsHelper

  def output_week
    if params[:start_at] and params[:end_at]
      "(#{params[:start_at]} ~ #{params[:end_at]})"
    else
      start_at = Time.now.beginning_of_week.year.to_s + "-" + Time.now.beginning_of_week.month.to_s + "-" + Time.now.beginning_of_week.day.to_s
      end_at = Time.now.end_of_week.year.to_s + "-" + Time.now.end_of_week.month.to_s + "-" + Time.now.end_of_week.day.to_s
      "(#{start_at} ~ #{end_at})"
    end
  end

  # 显示每周内以班级为单位完成成长记录的学员人数/班级人数
  def out_s_s_count(squad)
    unless squad.student_infos.blank?
      s_s_count = squad.student_infos.count
      raw "(已完成人数:<span class='s_s_count' style='color: #15a230;'></span>/总人数:#{s_s_count})"
    else
      raw "(已完成人数:<span class='s_s_count' style='color: #15a230;'></span>/总人数:0)"
    end
  end

  def cur_begin_week
     Time.now.beginning_of_week.year.to_s + "-" + Time.now.beginning_of_week.month.to_s + "-" + Time.now.beginning_of_week.day.to_s
  end

  def cur_end_week
     Time.now.end_of_week.year.to_s + "-" + Time.now.end_of_week.month.to_s + "-" + Time.now.end_of_week.day.to_s
  end
end
