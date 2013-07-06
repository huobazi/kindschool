#encoding:utf-8
ActiveAdmin.register GrowthRecord do
  menu :parent => "幼儿园管理", :priority => 17

  index do
    column :content
    column :start_at
    column :end_at
    column :kindergarten
    column :creater_id
    column :student_info
    column :squad_name
    default_actions
  end

  form do |f|
    f.inputs "学员成长记录" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :start_at, :required => true, :as => :just_datetime_picker
      f.input :end_at, :required => true, :as => :just_datetime_picker
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :content
      row :start_at
      row :end_at
      row :kindergarten
      row :creater_id
      row :student_info
      row :squad_name
    end
  end
end
