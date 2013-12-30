#encoding:utf-8
ActiveAdmin.register PersonalCredit do
  menu :parent => "积分商城", :priority => 15

  index do
    column :user
    column :credit
    column :kindergarten
    column :heap_credit
    default_actions
  end

  filter :user
  filter :kindergarten
  filter :credit
  filter :heap_credit


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
      row :heap_credit
    end
  end
end
