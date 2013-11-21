# encoding: utf-8
module MySchool::ManageHelper
	def choose_operate_show(controller_view)
		(session[:operates]||[]).include?(controller_view)
	end
	def calculated_figures
		str = current_user.name + current_user.role.try(:name).to_s
	    200-str.size
	end

  def paginate(scope, options = {}, &block)
    super + raw("<ul><li>每页#{scope.limit_value.to_s}/总共#{scope.total_count.to_s}</li></ul>")
  end

end
