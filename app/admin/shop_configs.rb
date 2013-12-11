#encoding:utf-8
ActiveAdmin.register ShopConfig do
  menu :parent => "积分商城", :priority => 15

  index do
    column :number
    column :name
    column :status,:default=>0
    default_actions
  end

  filter :number

  form do |f|
    f.inputs "商城配置" do
      f.input :number
      f.input :status
      f.input :name
    end
    f.inputs "详细内容" do
      f.input :note
    end
    if f.object.number == "logo"
      f.inputs "上传logo图片", :for => [:page_img, f.object.page_img || PageImg.new] do |img|
        img.input :uploaded_data,:as=>:file,:name => "asset_img"
      end
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :number
      row :status
      row :name
      row :note do
        raw(record.note)
      end
      unless record.page_img.blank?
        row :page_img do |obj|
          raw "<img src='#{obj.page_img.public_filename(:middle)}' />"
        end
      end
    end
  end
end
