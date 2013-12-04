#encoding:utf-8
ActiveAdmin.register SquadCredit do
  menu :parent => "积分管理", :priority => 15

  index do
    column :kindergarten
    column :squad
    column :credit
    default_actions
  end

  filter :kindergarten
  filter :squad


  form do |f|
    f.inputs "班级积分" do
      f.input :kindergarten
      f.input :squad
      f.input :credit
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :squad
      row :credit
    end
  end
end