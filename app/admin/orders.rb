#encoding:utf-8
#订单
ActiveAdmin.register Order  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :user
    column :number
    column :status do |record|
      Order::STATUS["#{record.status}"]
    end
    column :amount
    column :credit
    column :postage
    column :shipment_at
    column :address_info
    column :phone
    column :address
    column :delivery_address
    default_actions
  end

  filter :number
  filter :status
  
  form do |f|
    f.inputs "订单" do
      f.input :kindergarten
      f.input :user
      f.input :number
      f.input :status, :as=>:select,:collection=>Order::STATUS.invert, :required => true
      f.input :amount
      f.input :credit
      f.input :postage
      f.input :shipment_at
      f.input :express_code
      f.input :note
      f.input :address_info
      f.input :phone
      f.input :address
      f.input :delivery_address
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :user
      row :number
      # row :status
      row :status do
        Order::STATUS["#{menu.status}"]
      end
      row :amount
      row :credit
      row :postage
      row :shipment_at
      row :express_code
      row :note
      row :address_info
      row :phone
      row :address
      row :delivery_address
    end
  end
end