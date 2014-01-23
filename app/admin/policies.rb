#encoding:utf-8
ActiveAdmin.register Policies do
  menu :parent => "微壹平台", :priority => 1

  index do
    column :title
    column :kind_zone do |obj|
      obj.kind_zone.try(:zone_name)
    end
    default_actions
  end

  filter :title

  form do |f|
    f.inputs "政策法规" do
      f.input :title
      f.inputs "正文" do
        f.kindeditor :content, :required => true,:allowFileManager => false
      end
      f.inputs "选择所属地区" do
        KindZone.city_select(f.object).to_s.html_safe
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
      row :content
      row :kind_zone do
        menu.kind_zone.try(:zone_name)
      end
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
