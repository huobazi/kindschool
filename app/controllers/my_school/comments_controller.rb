#encoding:utf-8
class MySchool::CommentsController < MySchool::ManageController
  def index
    filter_resource
    if @record.blank?
      render :text=>"没有可查看的评论信息",:layout=>false
      return
    end
    if params[:last]
      comments = Comment.where(:kindergarten_id=>@kind.id,
        :resource_id=>params[:resource_id],
        :resource_type=>params[:resource_type]).page(params[:page] || 1).per(10)
      params[:page] = comments.total_pages
      params[:last] = nil
    end
    @comments = Comment.where(:kindergarten_id=>@kind.id,
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type]).page(params[:page] || 1).per(10)
    render :layout=>false
  end

  def virtual_delete
    filter_resource
    if @record.blank?
      flash[:commet_notice] = "您无法删除该评论"
      render :text => "您无法删除该评论", :status => 401
      return
    end

    @comment = Comment.find_by_id(params[:id])
    if current_user.get_users_ranges[:tp] == :all or @comment.user.id == current_user.id
      @level = params[:level].presence
      @comment.is_show = false
      @comment.deleted_at = Time.now.utc
      @comment.save
      respond_to do |format|
        format.js { render :layout => false }
      end
    else
     render :text => "没有权限或非法操作", :status => 401
    end
  end

  def modify
    binding.pry
    filter_resource
    if @record.blank?
      flash[:commet_notice] = "您无法编辑该评论"
      render :text => "您无法编辑该评论"
      return
    end

  end

  def send_comment
    filter_resource
    if @record.blank?
      flash[:commet_notice] = "您无法评论该信息。"
      render :text=>"您无法评论该信息",:layout=>false
      return
    end
    comment = Comment.new(:user_id=>current_user.id,
      :kindergarten_id=>@kind.id,
      :comment=>params[:comment],
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type])
    comment.save
    render :text=>""
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
