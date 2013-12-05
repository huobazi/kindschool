#encoding:utf-8
ActiveAdmin.register GrowthRecord do
  menu :parent => "幼儿园管理", :priority => 17

  index do
    column :content do |growth_record|
      truncate(growth_record.content)
    end
    column :tp do |growth_record|
      GrowthRecord::TP_DATA[growth_record.tp.to_s]
    end
    column :kindergarten
    column :start_at
    column :end_at
    column :creater
    column :student
    column :squad_name
    default_actions
  end

  form do |f|
    f.inputs "学员成长记录" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :start_at, :required => true, :as => :just_datetime_picker
      f.input :end_at, :required => true, :as => :just_datetime_picker
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :content
      row :start_at
      row :end_at
      row :kindergarten
      row :tp do |growth_record|
        GrowthRecord::TP_DATA[growth_record.tp.to_s]
      end
      row :creater
      row :student_info
      row :squad_name
      row :siesta
      row :dine
      row :reward
      div do
        br
        ul do
          record.asset_imgs.each do |img|
            li do
              raw("<img src=\"#{img.public_filename(:middle)}\" alt=\"照片\"/>")
            end
          end
        end
      end
      div do
        panel "评论" do
          render :partial=>"/my_school/comments/load_comments" ,:locals=>{:resource_type=>record.class.to_s,:resource_id=>record.id}
        end
      end
    end
  end
end
