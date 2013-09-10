#encoding:utf-8
class MySchool::ReadUsersController < MySchool::ManageController
  def index
    filter_resource
    if @record.blank?
      render :text=>"",:layout=>false
      return
    end
    unless ReadUser.find_by_kindergarten_id_and_user_id_and_resource_id_and_resource_type(@kind.id,current_user.id,@record.id,@record.class)
      read_user = ReadUser.new(:kindergarten_id=>@kind.id)
      read_user.resource = @record
      read_user.user = current_user
      read_user.user_name = current_user.name
      read_user.save
    end
    @read_users = ReadUser.where(:kindergarten_id=>@kind.id,
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type]).page(params[:read_users_page] || 1).order("created_at").per(20)
    render :layout=>false
  end

  protected
  def filter_resource
    if params[:resource_type] == "News"
      if @record =  News.find_by_id(params[:resource_id])
        #TODO: 判断是否可获取
      end
    elsif params[:resource_type] == "GrowthRecord"
      if current_user.get_users_ranges[:tp] == :student
        @record = @kind.growth_records.where("(creater_id = ? or student_info_id = ?)", current_user.id, current_user.student_info.id).find_by_id(params[:resource_id])
      elsif current_user.get_users_ranges[:tp] == :teachers
        @record = GrowthRecord.where("student_infos.squad_id in (select teachers.squad_id from teachers where teachers.staff_id = ?)",current_user.staff.id).joins("INNER JOIN student_infos on(student_infos.id = growth_records.student_info_id)").find_by_id(params[:resource_id])
      else
        @record = @kind.growth_records.find_by_id(params[:resource_id])
      end
    elsif params[:resource_type] == "CookBook"
      @record = @kind.cook_books.find_by_id(params[:resource_id])
    elsif params[:resource_type] == "Album"
      @record = @kind.albums.find_by_id(params[:resource_id])
    end
  end
end
