#encoding:utf-8
#邮寄地址
ActiveAdmin.register DeliveryAddress  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :user
    column :phone
    column :address
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "商品分类" do
      f.input :kindergarten
      f.input :user
      f.input :phone
      f.input :address
      f.input :address_info
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :user
      row :phone
      row :address
      row :address_info
    end
  end
end