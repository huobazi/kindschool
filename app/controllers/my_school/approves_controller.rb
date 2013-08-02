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
    if  @new = @kind.news.find(params[:new_id]) 
     if approve_record = @new.approve_record
        approve_record.status = params[:approve_record][:status] if params[:approve_record]
        approve_entry = ApproveEntry.new(:note=>params[:approve_entry][:note]) if params[:approve_entry]
        if approve_record.status==0
          approve_entry.status = 2
        else
          approve_entry.status = 1 
        end
        approve_entry.user = current_user
        approve_record.approve_entries << approve_entry
     else
       approve_record = ApproveRecord.new()
       approve_record.resource = @new
       approve_record.status = params[:approve_record][:status] if params[:approve_record]
       approve_entry = ApproveEntry.new(:note=>params[:approve_entry][:note]) if params[:approve_entry]
        if approve_record.status==0
          approve_entry.status = 2
        else
          approve_entry.status = 1 
        end
        approve_entry.user = current_user
        approve_record.approve_entries << approve_entry
     end
      if approve_record.save
       respond_to do |format|
       format.html { redirect_to(:action=>:news_show,:new_id=>@new.id) }
       format.xml  { head :ok }
      end
     end
    else
      flash[:notice]= "没有该新闻." 
      redirect_to :controller=>"home",:action=>"index"
    end
     
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
