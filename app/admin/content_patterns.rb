#encoding:utf-8
ActiveAdmin.register ContentPattern do
  menu :parent => "幼儿园管理", :priority => 21

  index do
    column :number
    column :kindergarten
    column :content
    column :name
    default_actions
  end

  form do |f|
    f.inputs "表格模版信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :number
      f.input :content
      f.input :name
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |t|
    attributes_table do
      row :number
      row :content
      row :name
      row :kindergarten
    end
  end
end

