#sencoding:utf-8
ActiveAdmin.register GardenNew do
  menu :parent => "园讯通管理", :priority => 14

  index do
    column :title
    column :creater
    column :created_at
    default_actions
  end

  filter :title
  filter :note

  form do |f|
    f.inputs "园讯通新闻" do
      f.input :title, :required => true
      f.input :created_at, :as => :just_datetime_picker
      f.input :note
    end
    f.inputs "正文" do
      f.kindeditor :content, :required => true,:allowFileManager => false
    end
    f.actions
  end

  show do |garden_new|
    attributes_table do
      row :title
      row :note
      row :content do
        raw garden_new.content
      end
      row :creater
      row :created_at
    end
  end
end
