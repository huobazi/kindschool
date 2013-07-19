# encoding: utf-8
module MySchool::ManageHelper
	def choose_operate_show(controller_view)
		puts "gggggggggggggggggggg\n\n\n\n"
		puts session[:operates].inspect
		session[:operates].include?(controller_view)

	end
	def calculated_figures
		str = current_user.name + current_user.role.try(:name).to_s
	    601-str.size-50
	end

end
