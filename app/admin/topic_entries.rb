#encoding:utf-8
ActiveAdmin.register TopicEntry do
  menu :parent => "幼儿园管理", :priority => 12

  index do
    column :content do |topic_entry|
      truncate(topic_entry.content)
    end
    column :creater
    column :topic
    column :human_goodback
    column :human_is_show
    default_actions
  end

  form do |f|
    f.inputs "发贴子" do
      f.input :content, :required => true
      f.input :topic, :input_html => { :disabled => true }
      f.input :goodback
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :content
      row :topic
      row :goodback
      row :creater
      row :human_is_show
    end
  end
end

