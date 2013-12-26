#encoding:utf-8
ActiveAdmin.register CreditGrade do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :tp_label
    column :credit_num
    column :name
    # default_actions
  end

  filter :kindergarten
  form do |f|
    f.inputs "积分等级管理" do
      f.input :kindergarten
      f.input :tp, :as=>:select,:collection=>CreditGrade::TP_DATA.invert, :required => true
      f.input :credit_num
      f.input :name
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :tp_label
      row :credit_num
      row :name
    end
  end
end
