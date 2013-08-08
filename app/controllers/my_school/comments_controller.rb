#encoding:utf-8
#学员菜谱
class MySchool::CommentsController < MySchool::ManageController
  def index
    filter_resource
    @comments = Comment.where(:kindergarten_id=>@kind.id,
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type]).page(params[:page] || 1).per(10).order("created_at DESC")
    render :layout=>false
  end

  def send_comment
    filter_resource
    comment = Comment.new(:user_id=>current_user.id,
      :kindergarten_id=>@kind.id,
      :comment=>params[:comment],
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type])
    comment.save
  end

  protected
  def filter_resource
    if params[:resource_type] == "News"
      if news =  News.find_by_id(params[:resource_id])
        #TODO: 判断是否可获取
      end
    elsif params[:resource_type] == "News"
      
    end
  end
end
