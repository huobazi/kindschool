#sencoding:utf-8
ActiveAdmin.register Notice do
  menu :parent => "幼儿园管理", :priority => 14

  controller do
    def new
      @notice = Notice.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @notice.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :title do |notice|
      truncate(notice.title)
    end
    column :kindergarten
    column :creater
    column :send_date
    column :approver_status_label
    default_actions
  end

  filter :kindergarten

  form do |f|
    f.inputs "通知信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :title, :required => true
      f.input :content, :required => true
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :content
      row :kindergarten
      row :creater
      row :approver_status_label
      row :approver_id
      row :send_date
      row :send_range_label
    end
  end
end
