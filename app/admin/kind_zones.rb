#encoding:utf-8
ActiveAdmin.register KindZone do
  menu :parent => "微壹平台", :priority => 1

  index do
    column :name
    column :remark
    column :code
    column :parent
    default_actions
  end

  filter :name
  filter :parent
  filter :code
  filter :created_at

  form do |f|
    f.inputs "幼儿园地区信息" do
      f.input :parent_id, :as=>:select,:collection=> nested_set_options(KindZone){|i, level| "#{'-' * level} #{i.name}" },:include_blank=>'===请选择==='
      f.input :name
      f.input :code
      f.input :remark
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :parent
      row :name
      row :code
      row :remark
    end
  end

end

