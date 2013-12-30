#encoding:utf-8
ActiveAdmin.register CreditGrade do
  menu :parent => "积分商城", :priority => 15

  index do
    column :tp_label
    column :credit_num
    column :name
    default_actions
  end

  filter :tp, :as => :select, :collection => CreditGrade::TP_DATA.invert
  filter :credit_num
  filter :name

  form do |f|
    f.inputs "积分等级管理" do
      f.input :tp, :as=>:select,:collection=>CreditGrade::TP_DATA.invert, :required => true
      f.input :credit_num
      f.input :name
    end
    f.inputs "上传积分等级图片", :for => [:page_img, f.object.page_img || PageImg.new] do |page_img|
      page_img.input :uploaded_data,:as=>:file
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :tp_label
      row :credit_num
      row :name
      if menu.page_img
        div do
          br
          panel "积分等级图片" do
            raw "<img src='#{menu.page_img.public_filename(:tiny)}' />"
          end
        end
      end
    end
  end
end
