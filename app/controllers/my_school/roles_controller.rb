#encoding:utf-8
#角色的管理
class MySchool::RolesController < MySchool::ManageController
   def index
	 @roles = @kind.roles
   end
end
