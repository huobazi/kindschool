#encoding:utf-8
ActiveAdmin.register PageContent do
  menu :parent => "幼儿园管理", :priority => 25

  controller do
    def new
      @page_content = PageContent.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @page_content.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  filter :kindergarten
  filter :number
  filter :name
  filter :note
  filter :created_at
  filter :updated_at
  filter :tp, :as => :select, :collection => PageContent::TP.invert

  index do
    column :kindergarten
    column :name
    column :logo_url do |page_content|
      raw "<img src='#{page_content.logo_url}' width='200' height='100' />"
    end
    column :note do |page_content|
      raw truncate(page_content.note)
    end

    default_actions
  end

  form do |f|
    f.inputs "页面内容信息" do
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :number
      f.input :name
      f.input :logo_url
      f.input :note
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :number
      row :name
      row :logo_url do |page_content|
        raw "<img src='#{page_content.logo_url}' width='200' height='100' />"
      end
      row :tp_label
      row :note do |page_content|
        raw page_content.note
      end
    end
  end
end
