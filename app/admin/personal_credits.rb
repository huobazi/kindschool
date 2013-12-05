#encoding:utf-8
ActiveAdmin.register PersonalCredit do
  menu :parent => "积分商城", :priority => 15

  index do
    column :user
    column :credit
    column :kindergarten
    default_actions
  end

  filter :user
  filter :kindergarten


  form do |f|
    f.inputs "个人积分管理" do
      f.input :kindergarten
      f.input :user
      f.input :credit
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :user
      row :credit
      row :kindergarten
    end
  end
end
