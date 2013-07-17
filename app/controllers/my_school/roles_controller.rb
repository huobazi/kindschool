#encoding:utf-8
#角色的管理
class MySchool::RolesController < MySchool::ManageController
   def index
	 @roles = @kind.roles.page(params[:page] || 1).per(10).order("created_at DESC")
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
        format.html { redirect_to my_school_roles_path, notice: '角色创建成功.' }
      else
        format.html { render action: "new" }
      end
    end
   end
   def update
     @role = @kind.roles.find(params[:id]) 
     respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to my_school_roles_path, notice: '角色更新成功.' }
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

end
