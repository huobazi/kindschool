#encoding:utf-8
ActiveAdmin.register WeixinDatabank do
  menu :parent => "资料库", :priority => 3
  member_action :share_users, :method => :get, :title => "推送" do
    @weixin_databank = WeixinDatabank.find(params[:id])
    @user_count = User.count(:conditions=>["(tp=0 or tp=1) and status=?","start"])
    @student_count = User.count(:conditions=>["tp=0 and status=?","start"])
  end
  member_action :share_users_load, :method => :post, :title => "提交推送" do
    if @weixin_databank = WeixinDatabank.find(params[:id])
      if params[:send_date].blank?
        flash[:error] = "推送时间不能为空"
      else
        weixin_share = WeixinShare.new(:send_date=>params[:send_date],:visible=>params[:visible],:weixin_databank_id=>@weixin_databank.id,:send_range=>params[:send_range])
        if params[:send_range] == 0
          if users = User.where("tp=0 and status=?","start").select("id,kindergarten_id")
            users.each do |user|
              weixin_share.weixin_share_users << WeixinShareUser.new(:user_id=>user.id,:kindergarten_id=>user.kindergarten_id)
            end
          end
        else
          if users = User.where("(tp=0 or tp=1) and status=?","start").select("id,kindergarten_id")
            users.each do |user|
              weixin_share.weixin_share_users << WeixinShareUser.new(:user_id=>user.id,:kindergarten_id=>user.kindergarten_id)
            end
          end
        end
        @weixin_databank.weixin_shares << weixin_share
        if @weixin_databank.save
          flash[:notice] = "发布成功"
        else
          flash[:error] = "发布失败"
        end
      end
      redirect_to :action => "show",:id=>@weixin_databank.id
    else
      flash[:error] = "资料不存在"
    end
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
    column "是否推送过" do |obj|
      obj.weixin_shares.blank? ? "未推送" : "已推送"
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

  show do |weixin_databak|
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
      div do
        br
        panel "推送分享" do
          if weixin_databak.weixin_shares.blank?
            "没有推送分享记录"
          else
            table_for(weixin_databak.weixin_shares) do |t|
              t.column("推送时间") {|item| item.send_date.to_short_datetime unless item.send_date.nil? }
              t.column("是否显示") {|item| item.visible ? "显示" : "隐藏" }
              t.column("推送范围") {|item| item.send_range == 0 ? "所有学生" : "学生和老师" }
              t.column("总人数") {|item| item.weixin_share_users.count}
              t.column("已读") {|item| item.weixin_share_users.where(:read_status=>1).count}
            end
          end
        end
      end
    end
  end
end
