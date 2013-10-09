#encoding:utf-8
#园长信箱的管理
class MySchool::DeanEmailsController < MySchool::ManageController
  def index
    @dean_emails = @kind.dean_emails.page(params[:page] || 1).per(10).order("created_at DESC")
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
   
  def create
    @dean_email = @kind.dean_emails.new(params[:dean_email])
    respond_to do |format|
      if @dean_email.save
        format.html { redirect_to my_school_dean_email_path(@dean_email), :success=> '园长信信发送成功.' }
      else
        format.html { render :action=> "new" }
      end
    end
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
   	@dean_email = @kind.dean_emails.where(:id=>params[:id])
    if @dean_email.destroy
      flash[:notice] = "删除成功"
    end
    respond_to do |format|
      format.html { redirect_to my_school_dean_emails_path }
      format.json { head :no_content }
    end
  end
end
