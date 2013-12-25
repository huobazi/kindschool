#encoding:utf-8
#商品分类
ActiveAdmin.register ProductCategory  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :name
    column :note
    column :parent
    default_actions
  end

  filter :name
  filter :parent

  form do |f|
    f.inputs "商品分类" do
      f.input :name
      f.input :note
      f.input :parent_id, :as=>:select,:collection=> nested_set_options(ProductCategory){|i, level| "#{'-' * level} #{i.name}" },:include_blank=>'===请选择==='#.inspect

    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :name
      row :note
      row :parent
    end
  end
end