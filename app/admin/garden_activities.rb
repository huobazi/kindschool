#sencoding:utf-8
ActiveAdmin.register GardenActivitie do
  menu :parent => "园讯通管理", :priority => 14
  member_action :delete_img, :method => :get do
    if(@garden_activitie = GardenActivitie.find_by_id(params[:id])) && (page_img = @garden_activitie.page_imgs.find(params[:img_id]))
      if page_img.destroy
        flash[:notice] ="操作成功."
      else
        flash[:error] = "操作失败."
      end
      redirect_to(:controller=>"/admin/garden_activities", :action=>:show,:id=>params[:id])
    else
      flash[:error] = "记录不存在."
      redirect_to(:controller=>"/admin/garden_activities", :action=>:index)
    end
  end
  
  index do
    column :title
    column :start_at
    column :end_at
    default_actions
  end

  filter :title
  filter :start_at
  filter :end_at

  
  form do |f|
    f.inputs "活动信息" do
      f.input :title, :required => true
      f.input :start_at, :as => :just_datetime_picker
      f.input :end_at, :as => :just_datetime_picker
    end
    f.inputs "简介" do
      f.kindeditor :note,:allowFileManager => false
    end
    f.inputs "详情界面" do
      f.kindeditor :content,:allowFileManager => false
    end
    f.inputs "上传滚动照片,建议比率239*177"  do
      f.has_many :page_imgs do |page_img|
        if !page_img.object.new_record?
          page_img.input :created_at, :as => :string, :input_html => {:disabled => true }
        end
        page_img.input :uploaded_data,:as=>:file
      end
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :title
      row :start_at
      row :end_at
      row :note do
        raw(record.note)
      end
      row :content do
        raw(record.content)
      end
      row :created_at
      div do
        br
        panel "滑动图片" do
          table_for(record.page_imgs) do |t|
            t.column("图片") {|item| raw "<img src='#{item.public_filename(:tiny)}' />"}
            t.column("操作") {|item| link_to "删除" ,:action=>:delete_img,:id=>record.id,:img_id=>item.id}
          end
        end
      end
    end
  end
end
