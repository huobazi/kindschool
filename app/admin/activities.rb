#encoding:utf-8
ActiveAdmin.register Activity do
  menu :parent => "幼儿园管理", :priority => 23

  controller do
    def new
      @activity = Activity.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @activity.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :title
    column :kindergarten
    column :start_at
    column :end_at
    column :creater
    column :tp_label
    column :squad_label
    column :activity_entries_count_label
    default_actions
  end

  form do |f|
    f.inputs "活动信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :title
      f.input :content
      f.input :start_at, :required => true, :as => :just_datetime_picker
      f.input :end_at, :required => true, :as => :just_datetime_picker
      f.input :tp, :as => :radio, :collection => {"活动" => 0, "兴趣讨论"=> 1}, :required => true
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :title
      row :tp_label
      row :squad_label
      row :note
      row :creater_id
      row :content do |activity|
        raw activity.content
      end
      row :approve_status_label
      row :approver
      row :activity_entries_count_label
    end
  end
end
