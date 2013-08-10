#encoding:utf-8
ActiveAdmin.register WeiyiConfig do
  menu :parent => "微壹平台管理", :priority => 1

  index do
    column :number
    column :content
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "微壹平台配置" do
      f.input :number, :required => true
      f.input :content
    end
    f.actions
  end

  show do
    attributes_table do
      row :number
      row :content
    end
  end
end
