#encoding:utf-8
#订单
ActiveAdmin.register Order  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :user
    column :number
    column :status
    column :amount
    column :credit
    column :postage
    column :shipment_at
    default_actions
  end

  filter :number
  filter :status
  
  form do |f|
    f.inputs "订单" do
      f.input :kindergarten
      f.input :user
      f.input :number
      f.input :status
      f.input :amount
      f.input :credit
      f.input :postage
      f.input :shipment_at
      f.input :express_code
      f.input :note
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :user
      row :number
      row :status
      row :amount
      row :credit
      row :postage
      row :shipment_at
      row :express_code
      row :note
    end
  end
end