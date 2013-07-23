#encoding:utf-8
class Weixin::GrowthRecordsController < Weixin::ManageController
  def index
    # unless params[:category_id].blank?
      # @topics = @kind.topics.where(:topic_category_id => params[:category_id].to_i).page(params[:page] || 1).per(10)
    # else
      # @topics = @kind.topics.page(params[:page] || 1).per(10)
    # end

    @growth_records = @kind.growth_records.where(:tp => 1).page(params[:page] || 1).per(10).order("created_at DESC")
  end

  def new
    @growth_record = GrowthRecord.new
    @growth_record.kindergarten_id = @kind.id
    @growth_record.creater_id = current_user.id
    @growth_record.tp = 1

    if (@grades = @kind.grades) && !@grades.blank?
      if (@squads = @grades.first.squads) && !@squads.blank?
        @student_infos = @squads.first.student_infos 
      end
    end
  end

  def grade_squad
  end

  def grade_student
  end

end

