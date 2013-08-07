#encoding:utf-8
#学员菜谱
class MySchool::CommentsController < MySchool::ManageController
  def index
    filter_resource
    @comments = Comment.where(:kindergarten_id=>@kind.id,
      :resource_id=>params[:resource_id],
      :resource_type=>params[:resource_type]).page(params[:page] || 1).per(10).order("created_at DESC")
    render :partial=>:index,:layout=>false
  end

 

  protected
  def filer_resource
    if params[:resource_type] == "News"
      if news =  News.find_by_id(params[:resource_id])
        #TODO: 判断是否可获取
      end
    elsif params[:resource_type] == "News"
      
    end
  end
end
