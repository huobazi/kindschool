#encoding:utf-8
ActiveAdmin.register EvaluateTemplate do
  menu :parent => "自评模板管理", :priority => 1

  index do
    column :name
    column :template_url
    column :note do |t|
        raw(t.note)
      end
    column :tp
    default_actions
  end

  form do |f|
    f.inputs "自评模板管理" do
      f.input :name
      f.input :template_url
      f.input :tp
    end
    f.inputs "描述" do
      f.kindeditor :note,:allowFileManager => false
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :name
      row :template_url
      row :note do |t|
        raw(t.note)
      end
      row :tp
    end
  end
end
