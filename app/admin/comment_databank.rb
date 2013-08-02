#encoding:utf-8
ActiveAdmin.register CommentDatabank do
  menu :parent => "资料库", :priority => 2

  index do
    column :content
    column :category
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    column :user
    default_actions
  end

  filter :category

  form do |f|
    f.inputs "微信资料库" do
      f.input :content, :required => true
      f.input :category, :required => true
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :content
      row :category
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
      row :user
      row :created_at
      row :updated_at
    end
  end
end
