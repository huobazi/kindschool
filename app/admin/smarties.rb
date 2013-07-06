#encoding:utf-8
ActiveAdmin.register Smarty do

  menu :parent => "系统配置", :priority => 4

  index do
    column :option_operate
    column :role
    column :rename
    default_actions
  end

  form do |f|
    f.inputs "常用功能" do
      f.input :option_operate, :required => true
      f.input :role, :required => true
      f.input :rename
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :option_operate
      row :role
      row :rename
    end
  end
end
