#encoding:utf-8
#常用功能设置
class MySchool::SmartiesController < MySchool::ManageController

def index
	@roles = @kind.roles
  if params[:role_id]
    @role = @kind.roles.find(params[:role_id].to_i)
  else
    @role = @roles.first
  end
  @role_operates = []
	# @role_operates = @role.operates.where(:visible=>true)
  (@role.option_operates||[]).each do |option_operate|
    @role_operate={}
     if operate = option_operate.operate#.where(:visible=>true)
       if operate.visible==true
        @role_operate[:id] = operate.id
        @role_operate[:parent_name] = operate.parent.name
        @role_operate[:name] = operate.name 
        # @role_operates[:rename] = option_operate.rename
        if @role.smarties.where(:option_operate_id=>option_operate.id).first
            @role_operate[:result] = true
        else
            @role_operate[:result] = false
        end
        @role_operates << @role_operate
       end
      end
    end
    @role_operates.uniq!
end

def create
   @role = @kind.roles.find(params[:role_id].to_i)
   @role.smarties.each do |smarty|
    smarty.destroy
   end
   if params[:operate] && option_operates = @role.option_operates.where(:operate_id=>params[:operate][:ids])
      option_operates.each do |option_operate|
      @smarty = Smarty.new(:option_operate_id=>option_operate.id,:role_id=>@role.id)
      @smarty.save!
    end
   end
  respond_to do |format|
    format.html { redirect_to my_school_smarties_path(:role_id=>@role.id), notice: '保存成功' }
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
