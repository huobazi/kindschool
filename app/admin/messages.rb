#sencoding:utf-8
ActiveAdmin.register Message do
  menu :parent => "幼儿园管理", :priority => 15
  controller do
    def new
      @message = Message.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @message.kindergarten = kindergarten
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
    column :sender_name
    column :tp
    column :approve_status
    column :send_date
    default_actions
  end

  filter :kindergarten

  form do |f|
    f.inputs "消息信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :title, :required => true
      f.input :content, :required => true
      f.input :chain_code
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :content
      row :kindergarten
      row :sender_name
      row :status
      row :approve_status
      row :approver_id
      row :parent_id
      row :entry_id
    end
  end
end

