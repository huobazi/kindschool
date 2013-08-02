#encoding:utf-8
ActiveAdmin.register WeixinDatabank do
  menu :parent => "资料库", :priority => 3

  index do
    column :title
    column :category
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    column :creater
    default_actions
  end

  filter :title
  filter :category

  form do |f|
    f.inputs "点评资料库" do
      f.input :title
      f.input :content, :required => true
      f.input :category, :required => true
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content
      row :category
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
      row :creater
      row :created_at
      row :updated_at
    end
  end
end
