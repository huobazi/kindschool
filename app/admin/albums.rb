#encoding:utf-8
ActiveAdmin.register Album do
  menu :parent => "幼儿园管理", :priority => 19

  index do
    column :title
    column :kindergarten
    column :is_show
    column :squad
    column :grade
    column :creater_id
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
      f.input :grade_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :title
      row :creater_id
      row :content
      row :is_show
      row :approve_status
      row :approver_id
      row :squad
      row :grade
      row :send_date
    end
  end
end
