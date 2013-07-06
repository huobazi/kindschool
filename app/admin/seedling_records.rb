#encoding:utf-8
ActiveAdmin.register SeedlingRecord do
  menu :parent => "幼儿园管理", :priority => 18

  index do
    column :student_info
    column :name
    column :kindergarten
    column :creater_id
    default_actions
  end

  form do |f|
    f.inputs "学员育苗记录" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :name
      f.input :note
      f.input :shot_at, :required => true, :as => :just_datetime_picker
      f.input :expire_at, :required => true, :as => :just_datetime_picker
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :student_info
      row :name
      row :creater_id
      row :kindergarten
      row :shot_at
      row :expire_at
      row :note
    end
  end
end

