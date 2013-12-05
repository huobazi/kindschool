#encoding:utf-8
ActiveAdmin.register PhysicalRecord do
  menu :parent => "幼儿园管理", :priority => 19

  index do
    column :student_info
    column :send_date
    column :creater
    column :kindergarten
    default_actions
  end

  form do |f|
    f.inputs "学员体检记录" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :send_date, :required => true, :as => :just_datetime_picker
      f.input :content
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :student_info
      row :creater
      row :send_date
      row :content do |t|
        raw t.content
      end
    end
  end
end


