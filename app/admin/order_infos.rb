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
    end
  end
end