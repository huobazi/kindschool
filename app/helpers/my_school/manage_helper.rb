module MySchool::ManageHelper
	def choose_operate_show(controller_view)
		session[:operates].include?(controller_view)
	end
end
