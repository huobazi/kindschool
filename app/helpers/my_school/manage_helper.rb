# encoding: utf-8
module MySchool::ManageHelper
	def choose_operate_show(controller_view)
		(session[:operates]||[]).include?(controller_view)
	end
	def calculated_figures
		str = current_user.name + current_user.role.try(:name).to_s
	    270-str.size-40
	end

end
