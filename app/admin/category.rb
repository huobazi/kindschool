#encoding:utf-8
ActiveAdmin.register Category do
  menu :parent => "资料库", :priority => 1

  index do
    column :name
    column :tp_label
    column :visible do |obj|
      obj.visible ? "显示" : "隐藏"
    end
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "资料分类" do
      f.input :name, :required => true
      f.input :tp, :as=>:select,:collection=>Category::TP_DATA.invert, :required => true
      f.input :visible
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :tp_label
      row :visible do |obj|
        obj.visible ? "显示" : "隐藏"
      end
    end
  end
end
