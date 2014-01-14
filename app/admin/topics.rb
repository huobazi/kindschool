#encoding:utf-8
ActiveAdmin.register Topic do
  menu :parent => "幼儿园管理", :priority => 11

  controller do
    def new
      @topic = Topic.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @topic.kindergarten = kindergarten
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
      link_to truncate(topic.title), :controller => "/admin/topics", :action => :show, :id => topic.id
    end
    column :creater
    column :kindergarten
    column :show_count
    column :squad_label
    column :topic_entires_count do |topic|
      topic.topic_entries.count
    end
    default_actions
  end

  filter :kindergarten
  filter :topic_category
  filter :creater
  filter :squad
  filter :title
  filter :content
  filter :is_show
  filter :is_top
  filter :approve_status, :as => :select, :collection => Topic::STATUS.invert

  form do |f|
    f.inputs "发贴子" do
      f.input :title, :required => true
      f.input :content, :required => true
      f.input :topic_category_id, :as => :select, :collection=>Hash[f.object.kindergarten.topic_categories.map{|topic_category| ["#{topic_category.name}",topic_category.id]}]
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :kindergarten_id,:as=>:hidden
      f.input :creater_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :creater_id
      row :kindergarten
      row :is_show do |topic|
        topic.is_show ? "是" : "否"
      end
      row :is_top do |topic|
        topic.is_top ? "是" : "否"
      end
      row :approve_status do |topic|
        Topic::STATUS[topic.approve_status]
      end
      row :approver
      row :show_count
      row :content do |topic|
        raw topic.content
      end
    end
  end
end
