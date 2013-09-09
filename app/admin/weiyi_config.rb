#encoding:utf-8
ActiveAdmin.register WeiyiConfig do
  menu :parent => "微壹平台管理", :priority => 1

  index do
    div do
      '编号："web_weiyi_about"为微一官网的关于我们,"web_weiyi_interact"为微一官网的家园互动,"web_weiyi_contact"为微一官网的联系我们'
    end
    column :number
    column :content  do |record|
      raw(record.content)
    end
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "微壹平台配置" do
      f.input :number, :required => true
    end
    f.inputs "配置内容" do
      if ["web_weiyi_about","web_weiyi_interact","web_weiyi_contact"].include?(f.object.number)
        f.kindeditor :content,:allowFileManager => false
      else
        f.input :content
      end
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :number
      row :content do
        raw(record.content)
      end
    end
  end
end
