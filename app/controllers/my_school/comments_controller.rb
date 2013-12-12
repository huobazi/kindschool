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

    @comment = Comment.find_by_id_and_kindergarten_id(params[:id], @kind.id)
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
    filter_resource
    if @record.blank?
      flash[:commet_notice] = "您无法编辑该评论"
      render :text => "您无法编辑该评论"
      return
    end

    comment = Comment.find_by_id_and_kindergarten_id(params[:id], @kind.id)
    unless comment.user.id == current_user.id
      flash[:error] = "没有权限或非法操作"
      redirect_to request.referer
    end
    comment.comment = params[:comment][:comment]
    if comment.save
      flash[:success] = "修改评论成功"
      redirect_to request.referer
    else
      flash[:error] = "修改评论失败"
      redirect_to request.referer
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
    #自己回复的不能进行加积分
    if comment.resource.creater.id != current_user.id
      if current_user.save_user_credit("comment",1,comment.resource)
       #反馈意见的要给发帖人加分
       comment.resource.creater.save_creater_credit("comment",comment.resource) if comment.resource.creater
      end
    end
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
