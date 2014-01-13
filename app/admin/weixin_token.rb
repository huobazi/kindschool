#encoding:utf-8
ActiveAdmin.register WeixinToken do
  menu :parent => "微壹平台", :priority => 1
  index do
    column :number
    column :appid
    column :secret
    column :access_token
    column :expires_in
    column :expires_at
    default_actions
  end

  form do |f|
    f.inputs "服务号token" do
      f.input :number, :required => true
      f.input :appid, :required => true
      f.input :secret, :required => true
      f.input :access_token
      f.input :expires_in
      f.input :expires_at
    end
    f.actions
  end

  show do
    attributes_table do
      row :number
      row :appid
      row :secret
      row :access_token
      row :expires_in
      row :expires_at
    end
  end
end

