#encoding:utf-8
#评估的管理
class MySchool::EvaluatesController < MySchool::ManageController
   def index
     @evaluates = @kind.evaluate
     if @evaluates.blank? 
     	@evaluate = Evaluate.new()
     else
     	@evaluate_entries = @evaluates.evaluate_entries.page(params[:page] || 1).per(10)
     end
     @download_package=@kind.download_package
   end
   def create
     @evaluate = Evaluate.new()
     @evaluate.kindergarten = @kind

      respond_to do |format|
        if @evaluate.save
          format.html { redirect_to my_school_evaluates_path, notice: '创建成功.' }
        else
          format.html { render action: "index" }
        end
      end
   end
   def destroy
     @evaluate = Evaluate.find(params[:id])
     @evaluate.destroy
    respond_to do |format|
      format.html { redirect_to my_school_evaluates_path, notice: '关闭成功.' }
      format.json { head :no_content }
    end
   end
   
   def download_packages
    require 'rubygems'     
    require 'zip/zip'
    if @kind.download_package
     @kind.download_package.update_attributes(:status=>true) 
    else
     @kind.download_package = DownloadPackage.create(:status=>true) 
    end
    evaluate = @kind.evaluate
    evaluate.delay.download_package 
    @download_package = @kind.download_package
    redirect_to my_school_evaluates_path
   end

   def download
   package = @kind.download_package
    if current_user.kindergarten == @kind
      path = "#{File.dirname(__FILE__)}/../../../stuff_to_zip/#{@kind.number}/#{@kind.number}.zip"
      send_file path, :x_sendfile=>true
    else
      redirect_to :back ,:notice=>"你没有权限下载"
    end
   end

end
