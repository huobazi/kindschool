#encoding:utf-8
#评估管理卷
class MySchool::EvaluateVtocsController < MySchool::ManageController
  def index

  end

  def new 
    @evaluate_entry = EvaluateEntry.find(params[:evaluate_entry_id])
  	@evaluate_vtoc = EvaluateVtoc.new()
  end

  def edit
    @evaluate_vtoc = EvaluateVtoc.find(params[:id])
    @evaluate_entry = @evaluate_vtoc.evaluate_entry
  end

  def update
     @evaluate_vtoc = EvaluateVtoc.find(params[:id])
     @evaluate_entry = @evaluate_vtoc.evaluate_entry
     respond_to do |format|
      if @evaluate_vtoc.update_attributes(params[:evaluate_vtoc])
        format.html { redirect_to my_school_evaluate_vtoc_path(@evaluate_vtoc), notice: '评估卷更新成功.' }
      else
        format.html { render action: "edit" }
      end
    end
   end

  def create
  	@evaluate_vtoc = EvaluateVtoc.new(params[:evaluate_vtoc])
    @evaluate_entry = EvaluateEntry.find(params[:evaluate_entry_id])
    @evaluate_vtoc.evaluate_entry_id = @evaluate_entry.id
    evaluate = @evaluate_entry.evaluate
    @evaluate_vtoc.kindergarten = @kind
    #给每个卷进行上传附件
    # unless params[:evaluate_asset].blank?
    #   (params[:evaluate_asset] || []).each do |p_evaluate_asset|
    #    evaluate_asset=EvaluateAsset.new(p_evaluate_asset)
    #    evaluate_asset.file_name = p_evaluate_asset[:avatar].original_filename if p_evaluate_asset[:avatar]
    #    @evaluate_vtoc.evaluate_assets << evaluate_asset
    #   end
    # end

    respond_to do |format|
        if @evaluate_vtoc.save
          format.html { redirect_to my_school_evaluate_evaluate_entry_path(evaluate.id,@evaluate_entry.id), notice: '创建成功.' }
        else
          format.html { render action: "new" }
        end
      end
  end

  #给管理的卷加添加附件的功能
  def create_evaluate_asset
    #给每个卷进行上传附件
    @evaluate_vtoc = EvaluateVtoc.find(params[:evaluate_vtoc_id])
    evaluate_entry = @evaluate_vtoc.evaluate_entry
   
    unless params[:evaluate_asset].blank?
      (params[:evaluate_asset] || []).each do |p_evaluate_asset|
       evaluate_asset=EvaluateAsset.new(p_evaluate_asset)
       evaluate_asset.kindergarten=@kind
       evaluate_asset.user=current_user
       evaluate_asset.file_name = p_evaluate_asset[:avatar].original_filename if p_evaluate_asset[:avatar]
       @evaluate_vtoc.evaluate_assets << evaluate_asset
      end
    end
    respond_to do |format|
        if @evaluate_vtoc.save
          format.html { redirect_to my_school_evaluate_vtoc_path(@evaluate_vtoc.id), notice: '创建成功.' }
        else
          format.html { redirect_to my_school_evaluate_vtoc_path(@evaluate_vtoc.id), notice: '创建成功.' }
        end
      end
  end

  def show
    @evaluate_vtoc = EvaluateVtoc.find(params[:id])
    @evaluate_entry = @evaluate_vtoc.evaluate_entry
    @evaluate_assets = @evaluate_vtoc.evaluate_assets.page(params[:page] || 1).per(10)
  end
  
  def delete_evaluate_asset
      evaluate_vtoc = EvaluateVtoc.find(params[:id])
      evaluate_asset = evaluate_vtoc.evaluate_assets.find(params[:evaluate_asset_id])
      evaluate_asset.destroy
    respond_to do |format|
      format.html { redirect_to my_school_evaluate_vtoc_path(evaluate_vtoc.id) }
      format.json { head :no_content }
    end

  end
   def download
    @evaluate_asset =EvaluateAsset.find(params[:id])
    if current_user.kindergarten == @evaluate_asset.kindergarten
      path = "/#{@evaluate_asset.avatar}"
      send_file path, :x_sendfile=>true
    else
      redirect_to :back ,:notice=>"你没有权限下载"
    end
  end

  def destroy
      @evaluate_vtoc = EvaluateVtoc.find(params[:id])
      @evaluate_entry = @evaluate_vtoc.evaluate_entry
      evaluate = @evaluate_entry.evaluate
    @evaluate_vtoc.destroy
    respond_to do |format|
      format.html { redirect_to my_school_evaluate_evaluate_entry_path(evaluate.id,@evaluate_entry.id) }
      format.json { head :no_content }
    end
   end


end
