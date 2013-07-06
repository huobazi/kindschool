#encoding:utf-8
ActiveAdmin.register Topic do
  menu :parent => "幼儿园管理", :priority => 11

  controller do
    def new
      @topic = Topic.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @topic.kindergarten = kindergarten
        if params[:squad_id] && (squad = Squad.find_by_id_and_kindergarten_id(params[:squad_id], params[:kindergarten_id]))
          @topic.squad = squad
        end
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end
  
  index do
    column :title do |topic|
      link_to topic.title, :controller => "/admin/topics", :action => :show, :id => topic.id
    end
    column :creater_id
    column :kindergarten
    column :tp
    column :squad
    column :status
    column :show_count
    default_actions
  end

  form do |f|
    f.inputs "发贴子" do
      f.input :title, :required => true
      f.input :content, :required => true
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :squad_label, :as => :string, :input_html => { :disabled => true }
      f.input :kindergarten_id,:as=>:hidden
      f.input :squad_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :creater_id
      row :kindergarten
      row :tp
      row :squad
      row :is_show
      row :is_top
      row :approve_status
      row :approver_id
      row :show_count
      row :content
    end
  end
end
