#encoding:utf-8
ActiveAdmin.register ShopConfig do
  menu :parent => "积分商城", :priority => 15

  index do
    column :number
    column :note
    column :status,:default=>0
    default_actions
  end

  filter :number

  form do |f|
    f.inputs "商城配置" do
      f.input :number
      f.input :note
      f.input :status
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :number
      row :status
      row :note
    end
  end
end
