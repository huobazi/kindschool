#encoding:utf-8
#审核内容
class MySchool::ApprovesController < MySchool::ManageController
  before_filter :kind_allow
   def index
   end
   def news_list
     @news = @kind.news.where(:approve_status=>1).page(params[:page] || 1).per(10) 
     
   end
   def news_show
   	 @new = @kind.news.find(params[:new_id])
   end
   def one_news_approve
     @new = @kind.news.find(params[:new_id]) 
     # format.html { redirect_to(:action=>:show,:id=>@grade.id) }
     # format.xml  { head :ok }
   end

  private
  def kind_allow
    approve_modules = @kind.approve_modules.where(:status=>true)
    if approve_modules.blank?
       flash[:notice]= "幼儿园没有设置审核功能." 
       redirect_to :controller=>"home",:action=>"index"
    else
       approve_user = current_user.approve_module_users.where(:approve_module_id=>approve_modules.collect(&:id))
       if approve_user.blank?
       	 flash[:notice]= "您没有审核内容的权限." 
         redirect_to :controller=>"home",:action=>"index"
       end
    end
  end
end
