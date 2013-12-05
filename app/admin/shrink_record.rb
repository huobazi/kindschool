#encoding:utf-8
#SEO搜素关键字记录表
ActiveAdmin.register ShrinkRecord do
  menu :parent => "微壹平台", :priority => 28

  controller do
    def new
      @shrink_record = ShrinkRecord.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @shrink_record.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end

  index do
    column :url
    column :description do |shrink_record|
      truncate shrink_record.description
    end
    column :keywords do |shrink_record|
      truncate shrink_record.keywords
    end
    column :kindergarten
    default_actions
  end

  form do |f|
    f.inputs "SEO搜索配置" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :url
      f.input :keywords
      f.input :description
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :url
      row :keywords
      row :description
      row :kindergarten
    end
  end
end
