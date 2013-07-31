#encoding:utf-8
#审核模块
class MySchool::ApproveModulesController < MySchool::ManageController
  def index
  	@data = current_user.get_users_ranges
  	@approve_modules = @kind.approve_modules.all
  
  end

  def edit
  	@approve_module = @kind.approve_modules.find(params[:id])
  end

end
