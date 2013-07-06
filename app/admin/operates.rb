#encoding:utf-8
ActiveAdmin.register Operate do
  menu :parent => "系统配置", :priority => 2

  index do
    column :name
    column :controller
    column :action
    column :params
    column :protocol
    column :note
    column :sequence
    column :authable
    column :visible
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "权限" do
      f.input :name, :required => true
      f.input :controller
      f.input :action
      f.input :params
      f.input :protocol
      f.input :note
      f.input :sequence
      f.input :level
      f.input :authable
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :controller
      row :action
      row :params
      row :protocol
      row :sequence
      row :level
      row :authable
      row :visible
    end
  end
end

