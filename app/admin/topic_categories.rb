#encoding:utf-8
ActiveAdmin.register TopicCategory do
  menu :parent => "幼儿园管理", :priority => 27

  controller do
    def new
      @topic_category = TopicCategory.new()
      if @kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @topic_category.kindergarten = @kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end


  index do
    column :name
    column :kindergarten_label
    default_actions
  end

  form do |f|
    f.inputs "论坛分类详细信息" do
      f.input :name
      f.input :kindergarten_label, :as => :string, :input_html => { :disabled => true }
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |f|
    attributes_table do
      row :name
      row :kindergarten_label
    end
  end
end


