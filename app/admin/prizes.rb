#encoding:utf-8
#奖品表
ActiveAdmin.register Prize do
  menu :parent => "积分商城", :priority => 15

  index do
    column :name
    column :beep
    column :content
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "奖品" do
      f.input :name, :required => true
      f.input :beep
      f.input :content
      f.input :content_url,:as=>:file,:required => true
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :beep
      row :beep_url
      row :content
      row :content_url
      row :status
    end
  end
end