#encoding:utf-8
#商品分类
ActiveAdmin.register ProductCategory  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :name
    column :note
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "商品分类" do
      f.input :name
      f.input :note
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :name
      row :note
    end
  end
end