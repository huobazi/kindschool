#encoding:utf-8
#后台资源库
ActiveAdmin.register ResourceLibrary do

  menu :parent => "微壹平台管理", :priority => 1
  index do
    column :file_name
    column :resource_avatar_url
    default_actions
  end
  
  filter :file_name

  form do |f|
  	f.inputs "后台资源库" do
  	 f.input :resource_avatar,:as=>:file,:required => true
     f.input :file_name
    end
    f.actions
  end
  show do |t|
    attributes_table do
      row :file_name
      row :resource_avatar
    end
  end
end
