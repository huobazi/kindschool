# encoding: utf-8
class  MySchool::ReportsController < MySchool::ManageController
  def create
    @report = current_user.reports.new
    if @report.create_report(params[:resource_type], params[:resource_id], @kind)
      flash[:success] = "举报成功"
      redirect_to params[:url]
    end
  end
end
