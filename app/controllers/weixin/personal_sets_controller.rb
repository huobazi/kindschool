#encoding:utf-8
#个人锦集
#
class Weixin::PersonalSetsController < Weixin::ManageController
  def index
    userrole = current_user.get_users_ranges[:tp]
    if userrole == :student
      @flag="student"
    elsif userrole == :teacher
      @flag= "teacher"
    end
  	@sets = current_user.personal_sets.search(params[:personal_set] || {}).page(params[:page] || 1).per(10)
  end
end