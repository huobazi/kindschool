#encoding:utf-8
ActiveAdmin.register HelpMovie do

  menu :parent => "微壹平台", :priority => 1
  index do
    # column :content do |obj|
    #   raw(obj.content)
    # end
    column :name

    default_actions
  end

  filter :name

  form do |f|
    f.inputs "视频配置" do
      f.input :name
    end
    f.inputs "视频内容" do
      f.kindeditor :content,:allowFileManager => false
    end
    f.actions
  end
  show do |t|
    attributes_table do
      row :name
      row :content do
        raw(t.content)
      end
    end
  end
end
