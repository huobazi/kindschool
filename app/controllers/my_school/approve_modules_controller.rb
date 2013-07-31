#encoding:utf-8
#审核模块
class MySchool::ApproveModulesController < MySchool::ManageController
  def index
  	@approve_modules = @kind.approve_modules.all
  
  end

  def edit
    @data = current_user.get_users_ranges
  	@approve_module = @kind.approve_modules.find(params[:id])
  end

  def update
    @approve_module=@kind.approve_modules.where(:id=>params[:id]).first
    

    (@approve_module.approve_module_users || []).each do |u_s|
      u_s.destroy
    end
    sender_ids = current_user.get_sender_users(params[:ids]||[])
    (sender_ids||[]).each do |user_id|
      if user = User.find_by_id_and_kindergarten_id(user_id,@kind.id)
        @approve_module.approve_module_users << ApproveModuleUser.new(:user_id=>user.id)
      end
    end
    respond_to do |format|
      if @approve_module.save && @approve_module.update_attributes(params[:approve_module])
        flash[:notice] = '更新成功.'
        format.html { redirect_to(my_school_approve_modules_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def get_edit_ids
  	if approve_module=@kind.approve_modules.where(:id=>params[:id]).first
      users_data = approve_module.approve_module_users.collect{|u_s| u_s.user}
      @data = users_data.group_by(&:tp)
      render :partial => "/my_school/messages/users",:layout=>false
    else
      render :text=>"您无法修改该信息"
    end
  end

end
