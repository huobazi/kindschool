#sencoding:utf-8
ActiveAdmin.register SysLog do
  menu :parent => "幼儿园管理", :priority => 14

  controller do
  end

  index do
    column :kindergarten
    column :user
    column :node
    column :url_chinese
    default_actions
  end

  filter :kindergarten
  filter :user#,:as => :text
  filter :url_chinese

  form do |f|
    # f.inputs "通知信息" do
    #   f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
    #   f.input :title, :required => true
    #   f.input :content, :required => true
    #   f.input :kindergarten_id, :as => :hidden
    # end
    # f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :user
      row :url_chinese
      row :node
      row :original_url
      row :method
      row :remote_ip
      row :url_params
    end
  end
end
