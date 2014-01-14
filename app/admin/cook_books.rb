#encoding:utf-8
ActiveAdmin.register CookBook do
  menu :parent => "幼儿园管理", :priority => 13

  controller do
    def new
      @cook_book = CookBook.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @cook_book.kindergarten = kindergarten
      else
        flash[:notice] = "需要指定所属幼儿园."
        redirect_to :action => :index,:controller=>"/admin/kindergartens"
        return
      end
      new!
    end
  end
  index do
    column :kindergarten
    column :start_at
    column :end_at
    column :range_tp do |t|
      CookBook::RANGE_TP_DATA["#{t.range_tp}"]
    end
    column :creater
    default_actions
  end

  filter :kindergarten
  filter :creater
  filter :start_at
  filter :end_at
  filter :range_tp, :as => :select, :collection => CookBook::RANGE_TP_DATA.invert
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "菜谱信息" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :start_at, :as => :just_datetime_picker
      f.input :end_at, :as => :just_datetime_picker
      f.input :range_tp, :as => :select, :collection => CookBook::RANGE_TP_DATA.invert
      f.input :content
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :kindergarten
      row :start_at
      row :end_at
      row :content do |t|
        raw t.content
      end
      row :range_tp do |t|
        CookBook::RANGE_TP_DATA["#{t.range_tp}"]
      end
      row :creater
    end
  end
end


