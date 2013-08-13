#encoding:utf-8
#SEO搜素关键字记录表
ActiveAdmin.register ShrinkRecord do
  menu :parent => "幼儿园管理", :priority => 28
  index do
    column :description
    column :keywords
    column :kindergarten
    default_actions
  end

  form do |f|
    f.inputs "SEO搜索配置" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :keywords
      f.input :description
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :keywords
      row :description
      row :kindergarten
    end
  end
end