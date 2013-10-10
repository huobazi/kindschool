#encoding:utf-8
#园长信箱的管理
class MySchool::DeanEmailsController < MySchool::ManageController
  def index
    @dean_emails = @kind.dean_emails.search(params[:dean_emails] || {}).page(params[:page] || 1).per(10).order("created_at DESC")
    store_search_location
  end

  def new
    @dean_email = @kind.dean_emails.new()
  end
   
  def edit
    @dean_email = @kind.dean_emails.find(params[:id])
  end
   
  def show
    @dean_email = @kind.dean_emails.find(params[:id])
  end
  
  def update
    @dean_email = @kind.dean_emails.find(params[:id])
    respond_to do |format|
      if @dean_email.update_attributes(params[:dean_email])
        format.html { redirect_to my_school_dean_email_path(@dean_email), :success=> '园长信信发送更新成功.' }
      else
        format.html { render :action=> "edit" }
      end
    end
  end

  def destroy
    unless params[:dean_email].blank?
      @dean_email = @kind.dean_emails.where(:id=>params[:dean_email])
    else
      @dean_email = @kind.dean_emails.where(:id=>params[:id])
    end
   	unless @dean_email.blank?
      @dean_email.each do |dean_email|
        dean_email.destroy
      end
      flash[:notice] = "操作成功"
    else
      flash[:notice] = "需要删除的记录不存在."
    end
    respond_to do |format|
      format.html { redirect_to my_school_dean_emails_path }
      format.json { head :no_content }
    end
  end
end
