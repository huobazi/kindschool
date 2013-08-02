#encoding:utf-8
ActiveAdmin.register WeixinShare do
  menu :parent => "资料库", :priority => 3

  index do
    column :weixin_databank do |obj|
      obj.weixin_databank ? obj.weixin_databank.title : "无相应资料"
    end
    column :send_at
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    default_actions
  end

  filter :send_at

  form do |f|
    f.inputs "微信资料库发布" do
      f.input :weixin_databank
      f.input :send_at, :required => true, :as => :just_datetime_picker
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :weixin_databank do |obj|
        obj.weixin_databank ? obj.weixin_databank.title : "无相应资料"
      end
      row :send_at
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
      row :created_at
      row :updated_at
    end
  end
end
