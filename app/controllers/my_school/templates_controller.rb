#encoding:utf-8
class  MySchool::TemplatesController < MySchool::ManageController

  def set_default_template_view
    @templates = Template.all
  end

  def set_default_template
    if (@template = Template.find_by_id(params[:template_id])) && (@template.is_default == false)
      if @un_default_template = Template.where(:is_default => true)
        @un_default_template.update_all(:is_default => false)
      end
      if @template.update_attributes(:is_default => true) && @kind.update_attributes(:template_id => params[:template_id])
        flash[:success] = "操作成功"
        redirect_to :controller => "/my_school/templates", :action => :set_default_template_view
      else
        flash[:error] = "操作失败"
        redirect_to :controller => "/my_school/templates", :action => :set_default_template_view
      end
    else
      flash[:error] = "该模版已经是默认模版或不存在该模版"
      redirect_to :controller => "/my_school/templates", :action => :set_default_template_view
    end
  end

end
