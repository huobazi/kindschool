#encoding:utf-8
#个人锦集
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

  def destroy
    @personal_set = current_user.personal_sets.find(params[:id])
    if @personal_set.nil?
       flash[:error] = "没有权限或相册不存在"
       redirect_to action: "index"
       return
     end
    @personal_set.destroy
    @personal_set.resource.destroy
    respond_to do |format|
      format.html { redirect_to weixin_personal_sets_path }
      format.json { head :no_content }
    end
  end
end