#encoding:utf-8
ActiveAdmin.register AssetImg do
  menu :parent => "幼儿园管理", :priority => 9

  collection_action :index, :method => :get do
    scope = AssetImg.where("resource_id IS NOT NULL").scoped
    @collection = scope.page() if params[:q].blank?
    @search = scope.metasearch(clean_search_params(params[:q]))
    respond_to do |format|
      format.html {
        render "active_admin/resource/index"
      }
    end
  end
  action_item :only => :show do
    link_to('添加图片', new_admin_asset_img_path("asset_img[resource_id]"=>asset_img.resource_id))
  end
  actions :new,:show,:index,:destroy,:create
  index :conditions=>"resource_id IS NOT NULL" do
    column :filename do |obj|
      raw "<img src='#{obj.public_filename(:thumb)}'  onerror='this.src='/assets/no_img.png'"
    end
    column :content_type
    default_actions
  end
  filter :content_type
  form do |f|
    f.inputs "图片" do
      f.input :uploaded_data,:as=>:file,:required => true
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :filename do |obj|
        raw "<img src='#{obj.public_filename(:thumb)}'  onerror='this.src='/assets/no_img.png'"
      end
      row :content_type
    end
  end
end                                   
