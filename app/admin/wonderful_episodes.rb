#encoding:utf-8
ActiveAdmin.register WonderfulEpisode do
  menu :parent => "幼儿园管理", :priority => 11

  controller do
    def new
      @wonderful_episode = WonderfulEpisode.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @wonderful_episode.kindergarten = kindergarten
        @wonderful_episode.user_id = current_admin_user.id
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :title do |wonderful_episode|
      link_to truncate(wonderful_episode.title), :controller => "/admin/wonderful_episode", :action => :show, :id => wonderful_episode.id
    end
    column :url_address
    column :creater
    column :kindergarten
    column :is_top
    column :squad
    default_actions
  end

  filter :kindergarten
  filter :creater
  filter :squad
  filter :title
  filter :is_top

  form do |f|
    f.inputs "创建精彩视频" do
      f.input :title, :required => true
      f.input :url_address, :required => true
      f.input :is_top
      f.input :squad_id, :as => :select, :collection=>Hash[f.object.kindergarten.squads.map{|squad| ["#{squad.name}",squad.id]}]
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :kindergarten_id,:as=>:hidden
      f.input :user_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :title
      row :url_address
      row :creater
      row :kindergarten_label
      row :squad_label
      row :is_top_label
    end
  end
end
