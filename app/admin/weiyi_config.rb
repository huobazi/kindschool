#encoding:utf-8
ActiveAdmin.register WeiyiConfig do
  menu :parent => "微壹平台", :priority => 1

  member_action :delete_img, :method => :get do
    if(@weiyi_config = WeiyiConfig.find_by_id(params[:id])) && (page_img = @weiyi_config.page_imgs.find(params[:img_id]))
      if page_img.destroy
        flash[:notice] ="操作成功."
      else
        flash[:error] = "操作失败."
      end
      redirect_to(:controller=>"/admin/weiyi_configs", :action=>:show,:id=>params[:id])
    else
      flash[:error] = "记录不存在."
      redirect_to(:controller=>"/admin/weiyi_configs", :action=>:index)
    end
  end

  index do
    div do
      raw '编号：<br/>"web_weiyi_about"为微一官网的关于我们,"web_weiyi_interact"为微一官网的家园互动,"web_weiyi_contact"为微一官网的联系我们,<br/>
            "web_garden_about"为园讯通简介,"web_garden_kindergarten"为推荐幼儿园(需要考虑在宽220，高140范围内显示),<br/>
            "web_garden_classic_users"为经典客户,"web_weiyi_video"为移动视频,"web_weiyi_scheme"为影视策划,<br/>
            "web_weiyi_cultivate"为动漫培训,"web_weiyi_benefit"为公益活动,"weiyi_tourism"为科技旅游,<br/>
            "weiyi_seo_description"为微一的seo描述,"weiyi_seo_keywords"为微一的seo关键字'
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
      if ["web_weiyi_about","web_weiyi_interact","web_weiyi_contact",
          "web_garden_kindergarten","web_garden_classic_users",
          "web_weiyi_video","web_weiyi_scheme","web_weiyi_cultivate","web_weiyi_benefit","weiyi_tourism"].include?(f.object.number)
        f.kindeditor :content,:allowFileManager => false
      else
        f.input :content
      end
    end
    if f.object.number == "web_garden_kindergarten"
      f.inputs "上传滚动照片,建议比率239*177"  do
        f.has_many :page_imgs do |page_img|
          if !page_img.object.new_record?
            page_img.input :created_at, :as => :string, :input_html => {:disabled => true }
          end
          page_img.input :uploaded_data,:as=>:file
        end
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
      if record.number == "web_garden_kindergarten"
        div do
          br
          panel "家园互动滑动图片" do
            table_for(record.page_imgs) do |t|
              t.column("图片") {|item| raw "<img src='#{item.public_filename(:tiny)}' />"}
              t.column("操作") {|item| link_to "删除" ,:action=>:delete_img,:id=>record.id,:img_id=>item.id}
            end
          end
        end
      end
    end
  end
end
