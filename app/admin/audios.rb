#encoding:utf-8
#资料音频表
ActiveAdmin.register Audio do
  menu :parent => "积分商城", :priority => 15

  index do
    column :kindergarten
    column :user
    column :audio_url
    default_actions
  end

  filter :user

  form do |f|
    f.inputs "资料音频" do
      f.input :kindergarten, :required => true
      f.input :user
    end
    f.actions
  end

  show do
    attributes_table do
      row :kindergarten
      row :user
      row :audio_url
    end
  end
end