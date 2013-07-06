#sencoding:utf-8
ActiveAdmin.register MessageEntry do
  menu :parent => "幼儿园管理", :priority => 16

  index do
    column :content
    column :message
    column :receiver_name
    column :status
    column :sms
    column :phone
    default_actions
  end

  show do |menu|
    attributes_table do
      row :message
      row :receiver_name
      row :status
      row :sms
      row :phone
      row :content
    end
  end
end
