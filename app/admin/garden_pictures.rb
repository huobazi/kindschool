#sencoding:utf-8
ActiveAdmin.register GardenPicture do
  menu :parent => "园讯通管理", :priority => 14

  index do
    column :title
    column :tp
    default_actions
  end

  filter :title
  filter :tp

  form do |f|
    f.inputs "园讯通照片集锦" do
      f.input :title, :required => true
      f.input :tp
    end
    f.inputs "上传滚动照片", :for => [:page_img, f.object.page_img || PageImg.new] do |page_img|
      page_img.input :uploaded_data,:as=>:file
    end
    f.actions
  end

  show do |garden_picture|
    attributes_table do
      row :title
      row :tp
      row :created_at
      if garden_picture.page_img
        div do
          br
          panel "照片" do
            raw "<img src='#{garden_picture.page_img.public_filename(:tiny)}' />"
          end
        end
      end
    end
  end
end
