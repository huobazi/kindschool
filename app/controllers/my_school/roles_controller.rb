#encoding:utf-8
#角色的管理
class MySchool::RolesController < MySchool::ManageController
   def index
	 @roles = @kind.roles.page(params[:page] || 1).per(10)#.order("created_at DESC")
   end
   def new
   	 @role = @kind.roles.new()
   end
   def edit
     @role = @kind.roles.find(params[:id]) 
   end
   def show
   	 @role = @kind.roles.find(params[:id])
   	 unless @role.option_operates.blank?
   	 	@options = @role.option_operates.group_by{|option| option.operate && option.operate.parent ? option.operate.parent.name : ""}
   	 end
   end
   def create
   	 @role = @kind.roles.new(params[:role])
   	 respond_to do |format|
      if @role.save
        format.html { redirect_to my_school_role_path(@role), success: '角色创建成功.' }
      else
        format.html { render action: "new" }
      end
    end
   end
   def update
     @role = @kind.roles.find(params[:id]) 
     respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to my_school_role_path(@role), success: '角色更新成功.' }
      else
        format.html { render action: "new" }
      end
    end
   end

   def destroy
   	@roles = @kind.roles.where(:id=>params[:id])
    @roles.each do |role|
      if role.users.blank?
         role.destroy
      end
     end
    respond_to do |format|
      format.html { redirect_to my_school_roles_path }
      format.json { head :no_content }
    end
   end
   #为该角色分配权限
   def set_operate_to_role
     @role = @kind.roles.where(:id=>params[:id]).first
     @option_operates = @kind.option_operates.group_by{|option_operate| option_operate.operate && option_operate.operate.parent ? option_operate.operate.parent.name : ""}
   end

   def save_operate_to_role
     if @role = @kind.roles.where(:id=>params[:id]).first
       ids = params[:operate] || []
       if ids.blank?
         @role.option_operates.each do |operate|
         operate.destroy
         end
       else
         delete_ids = []
         @role.option_operates.each do |option|
           unless ids.include?(option.id.to_s)
             delete_ids << option
           end
         end
         @role.option_operates.destroy(delete_ids) unless delete_ids.blank?
       end
       ids.each do |option_operate_id|
         if option = OptionOperate.find_by_id_and_kindergarten_id(option_operate_id,@role.kindergarten_id)
           @role.option_operates << option unless @role.option_operates.include?(option)
         end
       end
       @role.save!
       @success = '角色设置权限成功.' 
      else
       @success = '角色不存在,没有设置权限.'
      end
      respond_to do |format|
        format.html { redirect_to my_school_role_path(@role), success:@success }
        format.json { head :no_content }
      end
    end
end
