#encoding:utf-8
ActiveAdmin.register ActivityEntry do
  menu :parent => "幼儿园管理", :priority => 24

  index do
    column :note do |obj|
      raw truncate(obj.note, :length => 360)
    end
    column :tp do |obj|
      obj.tp ? "活动" : "兴趣讨论"
    end
    column :activity
    column :creater_id do |obj|
      obj.creater.try(:name)
    end
    column :activity_img do |obj|
      if obj.activity_img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.activity_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
      end
    end
    default_actions
  end

  form do |f|
    f.inputs "活动详细信息" do
      f.input :note
    end
    f.inputs "图片", :for => [:activity_img, f.object.activity_img || ActivityImg.new] do |img|
      img.input :uploaded_data,:as=>:file,:name => "activity_img"
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :note
      row :activity
      row :tp
      row :creater_id
      row :activity_img do |obj|
        if obj.activity_img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.activity_img.public_filename(:tiny)}'  onerror='this.src='/assets/no_img.png'"
        end
      end
    end
  end
end
