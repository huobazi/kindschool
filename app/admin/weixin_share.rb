#encoding:utf-8
ActiveAdmin.register WeixinShare do
  menu :parent => "资料库", :priority => 3

  index do
    column :weixin_databank do |obj|
      obj.weixin_databank ? obj.weixin_databank.title : "无相应资料"
    end
    column :send_date
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    default_actions
  end

  filter :send_at

  form do |f|
    f.inputs "微信资料库发布" do
      f.input :weixin_databank
      f.input :send_date, :required => true, :as => :just_datetime_picker
      f.input :visible
    end
    f.actions
  end

  show do |weixin_share|
    attributes_table do
      row :weixin_databank do |obj|
        obj.weixin_databank ? obj.weixin_databank.title : "无相应资料"
      end
      row :send_date
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
      row :created_at
      row :updated_at
      div do
        br
        panel "推送分享详细" do
          if weixin_share.weixin_share_users.blank?
            "没有推送分享详细记录"
          else
            table_for(weixin_share.weixin_share_users) do |t|
              t.column("用户") {|item| item.user ? (auto_link item.user) : "已不存在" }
              t.column("所属幼儿园") {|item| item.kindergarten ? (auto_link item.kindergarten) : "已不存在" }
              t.column("阅读状态") {|item| item.read_status ? "已读" : "未读" }
              t.column("阅读时间") {|item| item.read_at  ? item.read_at.to_short_datetime : ""}
            end
          end
        end
      end
    end
  end
end
