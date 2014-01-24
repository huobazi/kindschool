#encoding:utf-8
ActiveAdmin.register Policy do
  menu :parent => "微壹平台", :priority => 1

  member_action :set_kind_zone_view, :method => :get, :title => "为政策法规分配地区" do
    @policy = Policy.find_by_id(params[:id])
    @kind_zone_roots = KindZone.roots
  end

  member_action :set_kind_zone, :method => :put do
    @policy = Policy.find_by_id(params[:id])
    if @policy.update_attributes(params[:policy])
      flash[:success] = "操作成功"
      redirect_to :action => :show, :controller => "/admin/policies", :id => @policy.id
    else
      flash[:error] = "操作失败"
      redirect_to :action => :index, :controller => "/admin/policies"
    end
  end

  action_item :only => :show do
    link_to('分配地区', set_kind_zone_view_admin_policy_path(policy))
  end

  index do
    column :title
    column :kind_zones_label
    default_actions
  end

  filter :title

  form do |f|
    f.inputs "政策法规" do
      f.input :title
      f.inputs "正文" do
        f.kindeditor :content, :required => true,:allowFileManager => false
      end
      f.inputs "上传图片", :for => [:asset_img, f.object.asset_img || AssetImg.new] do |img|
        img.input :uploaded_data,:as=>:file,:name => "asset_img"
      end
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :content do |obj|
        raw obj.content
      end
      row :kind_zones_label
      row :asset_img do |obj|
        if obj.asset_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.asset_img.public_filename(:middle)}'  onerror='this.src='/assets/no_img.png'/>"
        end
      end
      
    end
  end

end
