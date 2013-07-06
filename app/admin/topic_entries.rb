#encoding:utf-8
ActiveAdmin.register TopicEntry do
  menu :parent => "幼儿园管理", :priority => 12

  index do
    column :content
    column :creater_id
    column :status
    column :topic
    default_actions
  end

  form do |f|
    f.inputs "发贴子" do
      f.input :content, :required => true
      f.input :topic, :input_html => { :disabled => true }
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :content
      row :topic
      row :creater_id
      row :status
    end
  end
end

