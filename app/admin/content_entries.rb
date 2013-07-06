#encoding:utf-8
ActiveAdmin.register ContentEntry do
  menu :parent => "幼儿园管理", :priority => 26

  index do
    column :page_content
    column :title
    column :number
    column :content
    column :page_img do |obj|
      if obj.page_img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.page_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
      end
    end
    default_actions
  end

  form do |f|
    f.inputs "页面内容详细信息" do
      f.input :page_content
      f.input :title
      f.input :number
      f.input :content
    end
    f.inputs "图片", :for => [:page_img, f.object.page_img || PageImg.new] do |img|
      img.input :uploaded_data,:as=>:file,:name => "page_img"
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :page_content
      row :number
      row :title
      row :content
      row :page_img do |obj|
        if obj.page_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.page_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
        end
      end
    end
  end
end

