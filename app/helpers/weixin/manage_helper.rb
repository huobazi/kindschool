# encoding: utf-8
module Weixin::ManageHelper
	def choose_operate_show(controller_view)
		(session[:operates]||[]).include?(controller_view)
	end
end
