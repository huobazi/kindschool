#sencoding:utf-8
#商家
ActiveAdmin.register Merchant do
  menu :parent => "积分商城", :priority => 15

  index do
    column :name
    column :status_label
    column :asset_img do |obj|
      if obj.asset_img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.asset_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
      end
    end
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "商家信息" do
      f.input :name, :required => true
      f.input :status, :as=>:select , :collection => Merchant::STATUS_DATA.invert
      f.inputs "上传logo图片", :for => [:asset_img, f.object.asset_img || AssetImg.new] do |img|
        img.input :uploaded_data,:as=>:file,:name => "asset_img"
      end

    end
    f.inputs "商家页面内容" do
      f.kindeditor :note,:allowFileManager => false
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :name
      row :status do |obj|
        Merchant::STATUS_DATA["#{obj.status}"]
      end
      row :asset_img do |obj|
        if obj.asset_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.asset_img.public_filename(:middle)}'  onerror='this.src='/assets/no_img.png'/>"
        end
      end
      row :note do
        raw(record.note)
      end
    end
  end
end
