#encoding:utf-8
ActiveAdmin.register ShowCase do
  menu :parent => "幼儿园管理", :priority => 13

  controller do
    def new
      @show_case = ShowCase.new()
      if kindergarten = Kindergarten.find_by_id(params[:kindergarten_id])
        @show_case.kindergarten = kindergarten
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
    column :creater
    column :title
    default_actions
  end

  filter :kindergarten
  filter :created_at

  form do |f|
    f.inputs "展示作品" do
      f.input :kindergarten_label, :required => true, :input_html => { :disabled => true }
      f.input :creater
      f.input :user
      f.input :title
      f.input :note
      f.input :asset_img
      f.input :kindergarten_id, :as => :hidden
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :kindergarten
      row :creater
      row :user
      row :title
      row :note
      row :asset_img do |obj|
        if obj.img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.img.public_filename(:tiny)}' />"
        end
      end
    end
  end
end


