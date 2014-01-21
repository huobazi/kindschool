#encoding:utf-8
#幼儿园网站设置
class MySchool::MyKindergartenController < MySchool::ManageController
  def index
    
  end

  def edit
    
  end

  def update
    @kind.name = params[:name]
    @kind.note = params[:note]
    @kind.latlng = params[:latlng]
    @kind.address = params[:address]
    @kind.telephone = params[:telephone]
    @kind.login_note = params[:login_note]
    @kind.show_cookbook = params[:show_cookbook] == "1" ? true : false
    if params[:asset_logo]
      if @kind.asset_img
        @kind.asset_img.update_attribute(:uploaded_data, params[:asset_logo])
      else
        @kind.asset_img = AssetImg.new(:uploaded_data=> params[:asset_logo])
      end
    end
    respond_to do |format|
      if @kind.save
        flash[:notice] = '网站信息成功.'
        format.html { redirect_to(:action=>:index) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @kind.errors, :status => :unprocessable_entity }
      end
    end
  end
end
