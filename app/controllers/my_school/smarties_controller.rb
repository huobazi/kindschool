#encoding:utf-8
#常用功能设置
class MySchool::SmartiesController < MySchool::ManageController

def index
	@roles = @kind.roles
	@role = @roles.first
	@role_operates = @role.operates.where(:visible=>true)
end

def create
   @role = @kind.roles.find(params[:role_id].to_i)
   @smarty = Smarty.new()
	respond_to do |format|
      #if @smarty.save!
        format.html { redirect_to my_school_smarties_path, notice: '学员的育苗 was successfully created.' }
      # else
      #   format.html { render :action=> "new" }
      # end
    end
end

def role_operates
@roles = @kind.roles
	# @hash = {}
@role = @roles.find(params[:role_id].to_i)
@role_operates = @role.operates.where(:visible=>true)
render :partial => 'role_operates' , :layout => false
end

end
