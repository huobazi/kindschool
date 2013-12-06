#encoding:utf-8
#订单详细
ActiveAdmin.register OrderInfo  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :order
    column :product
    column :kindergarten
    column :amount
    column :credit
    column :count
    column :comment
    column :quality
    column :address_info
    column :phone
    column :address
    column :delivery_address
    default_actions
  end

  filter :product
  filter :phone
  
  form do |f|
    f.inputs "订单详情" do
      f.input :order
      f.input :product
      f.input :kindergarten
      f.input :amount
      f.input :credit
      f.input :count
      f.input :comment
      f.input :quality
      f.input :address_info
      f.input :phone
      f.input :address
      f.input :delivery_address
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :order
      row :product
      row :kindergarten
      row :amount
      row :credit
      row :count
      row :comment
      row :quality
      row :address_info
      row :phone
      row :address
      row :delivery_address
    end
  end
end