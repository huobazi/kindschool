#encoding:utf-8
ActiveAdmin.register Album do
  menu :parent => "幼儿园管理", :priority => 19

  index do
    column :title
    column :kindergarten_label
    column :is_show_label
    column :squad_label
    column :creater
    default_actions
  end

  form do |f|
    f.inputs "活动相册信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :squad_label, :required => true, :input_html => { :disabled => true }
      f.input :grade_label, :required => true, :input_html => { :disabled => true }
      f.input :title
      f.input :content
      f.input :is_show, :as => :boolean
      f.input :kindergarten_id, :as => :hidden
      f.input :squad_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten_label
      row :title
      row :creater
      row :content
      row :is_show_label
      row :approve_status
      row :approver_id
      row :squad_label
      row :send_date
    end
  end
end
