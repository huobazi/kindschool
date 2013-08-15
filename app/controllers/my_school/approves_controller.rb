#encoding:utf-8
#审核内容
class MySchool::ApprovesController < MySchool::ManageController
  before_filter :kind_allow ,:except=>[:get_approve_record_log]
   def index
   end
   def news_list
     @news = @kind.news.where(:approve_status=>1).page(params[:page] || 1).per(10)  
   end
   def news_show
   	 @new = @kind.news.find(params[:new_id])
     if approve_record=@new.approve_record
       @approve_entries = approve_record.approve_entries
     end
   end

   def activities_list
     @activities = @kind.activities.where(:approve_status=>1).page(params[:page] || 1).per(10)  
   end

   def activity_show
     @activity = @kind.activities.find(params[:activity_id])
     if approve_record=@activity.approve_record
       @approve_entries = approve_record.approve_entries
     end
   end

   def messages_list
     @messages = @kind.messages.where(:approve_status=>1,:status=>true).page(params[:page] || 1).per(10)
   end
   def message_show
    @message = @kind.messages.find(params[:message_id])
    if approve_record = @message.approve_record
       @approve_entries = approve_record.approve_entries      
    end
   end

   def notices_list
     @notices = @kind.notices.where(:approve_status=>1).page(params[:page] || 1).per(10)  
   end

   def notice_show
     @notice = @kind.notices.find(params[:notice_id])
     if approve_record=@notice.approve_record
       @approve_entries = approve_record.approve_entries
     end
   end

   def topics_list
     @topics = @kind.topics.where(:approve_status=>1).page(params[:page] || 1).per(10)  
   end

   def topic_show
     @topic = @kind.topics.find(params[:topic_id])
     if approve_record=@topic.approve_record
       @approve_entries = approve_record.approve_entries
     end
   end

   def one_news_approve
    if approve_record = ApproveRecord.find(params[:approve_record_id])
        if  params[:approve_record] && params[:approve_record][:status]=="0"
         unless approve_record.status == 2
           approve_record.status =2  
         end
        elsif params[:approve_record] && params[:approve_record][:status]=="1"
         unless approve_record.status == 0
           approve_record.status = 0 
         end
        end
        approve_entry = ApproveEntry.new(:note=>params[:approve_entry][:note]) if params[:approve_entry]
        if approve_record.status==2
          approve_entry.status = 2
        else
          approve_entry.status = 1 
        end
        approve_entry.user = current_user
        approve_record.approve_entries << approve_entry
     else
      flash[:notice]= "没有该记录." 
      redirect_to :controller=>"home",:action=>"index"
     end
     # end
      if approve_record.save
       respond_to do |format|
       if approve_record.resource_type == "News"
         format.html { redirect_to(:action=>:news_show,:new_id=>approve_record.resource.id) }
       elsif approve_record.resource_type == "Activity"
         format.html { redirect_to(:action=>:activity_show,:activity_id=>approve_record.resource.id) }
       elsif approve_record.resource_type == "Notice"
         format.html { redirect_to(:action=>:notice_show,:notice_id=>approve_record.resource.id) } 
       elsif approve_record.resource_type == "Message"
         format.html { redirect_to(:action=>:message_show,:message_id=>approve_record.resource.id) } 
       elsif approve_record.resource_type == "Topic"
         format.html { redirect_to(:action=>:topic_show,:topic_id=>approve_record.resource.id) } 
       end
       format.xml  { head :ok }
      end
     end
  end

  def get_approve_record_log
    if approve_record = ApproveRecord.find_by_id(params[:id])
      @approve_entries = approve_record.approve_entries
      render :partial=>"/my_school/approves/approve_list_from",:layout=>false
    else
      render :text=>"审核不存在。",:layout=>false
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
