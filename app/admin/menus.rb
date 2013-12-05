#encoding:utf-8
ActiveAdmin.register Menu do
  menu :parent => "系统配置", :priority => 3
  controller do
    def new
      @menu = Menu.new()
      if params[:parent_id] && (menu = Menu.find_by_id(params[:parent_id]))
        @menu.parented = menu
        @menu.kindergarten = menu.kindergarten
      elsif params[:kindergarten_id] && (@kindergarten = Kindergarten.find_by_id(params[:kindergarten_id]))
        @menu.kindergarten = @kindergarten
      end
      new!
    end
  end
  index do
    column :number
    column :name
    column :sequence
    column :parented
    column :url
    column :title
    column :visible_label
    column :operate_id
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "权限" do
      f.input :kindergarten
      f.input :number, :required => true
      f.input :name, :required => true
      f.input :parented
      f.input :sequence
      f.input :url
      f.input :title
      f.input :visible
      f.input :height_level
      f.input :operate_id
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :number
      row :sequence
      row :name
      row :parented
      row :url
      row :title
      row :visible_label
      row :operate_id
      div do
        br
        panel "子菜单" do
          unless menu.children.blank?
            table_for(menu.children) do |t|
              t.column("编号") {|item| item.number }
              t.column("名称") {|item| auto_link item.name }
              t.column("排序") {|item| item.sequence }
              t.column("url配置") {|item| item.url }
              t.column("是否可见") {|item| item.visible ? "可见" : "隐藏" }
              t.column("tip提示") {|item| item.title }
            end
          end
        end
        ul do
          li do
            link_to "添加子菜单",:controller=>"/admin/menus",:action=>:new,:id=>nil,:parent_id=>menu.id
          end
        end
      end
    end
  end
end

