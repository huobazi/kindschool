#encoding:utf-8
ActiveAdmin.register CareerStrategy do
  menu :parent => "幼儿园管理", :priority => 10
  
  index do
    column :kindergarten
    column :graduation
    column :add_squad
    column :from_id
    column :to_id
    default_actions
  end

  filter :kindergarten

  form do |f|
    f.inputs "班级升级策略" do
      f.input :kindergarten, :required => true
      f.input :graduation
      f.input :add_squad
      f.input :from_id
      f.input :to_id
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :graduation
      row :add_squad
      row :from_id
      row :to_id
    end
  end
end
