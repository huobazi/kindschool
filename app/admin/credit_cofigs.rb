#encoding:utf-8
ActiveAdmin.register CreditCofig do
  menu :parent => "积分管理", :priority => 15

  index do
    column :number
    column :name
    column :credit
    column :note
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "积分配置" do
      f.input :number
      f.input :name
      f.input :credit
      f.input :note
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :number
      row :name
      row :credit
      row :note
    end
  end
end


