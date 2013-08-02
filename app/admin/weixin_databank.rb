#encoding:utf-8
ActiveAdmin.register WeixinDatabank do
  menu :parent => "资料库", :priority => 3
  member_action :share_users, :method => :get, :title => "推送" do
    @weixin_databank = WeixinDatabank.find(params[:id])
  end
  member_action :share_users_load, :method => :get, :title => "提交推送" do
    @weixin_databank = WeixinDatabank.find(params[:id])
  end
  action_item :only => :show do
    link_to('添加推送', url_for(:action=>:share_users,:id=>weixin_databank.id))
  end
  index do
    column :title
    column :category
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    default_actions
  end

  filter :title
  filter :category

  form do |f|
    f.inputs "点评资料库" do
      f.input :title
      f.input :content, :required => true
      f.input :category, :required => true
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content
      row :category
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
      row :creater
      row :created_at
      row :updated_at
      
    end
  end
end
