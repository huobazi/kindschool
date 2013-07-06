#encoding:utf-8
ActiveAdmin.register AlbumEntry do
  menu :parent => "幼儿园管理", :priority => 20

  index do
    column :album
    column :asset_img do |obj|
      if obj.asset_img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.asset_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
      end
    end
    default_actions
  end

  form do |f|
    f.inputs "上传图片", :for => [:asset_img, f.object.asset_img || AssetImg.new] do |img|
      img.input :uploaded_data,:as=>:file,:name => "asset_img"
    end
    f.actions
  end

  show do |t|
    attributes_table do
      row :album
      row :asset_img do |obj|
        if obj.asset_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.asset_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
        end
      end
    end
  end
end
