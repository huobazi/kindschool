#encoding:utf-8
ActiveAdmin.register Product  do
  menu :parent => "积分商城", :priority => 15

  index do
    column :name
    column :credit
    column :price
    column :market_price
    column :keywords
    column :meaning
    column :status
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "上传商品" do
      f.input :name
      f.input :credit
      f.input :product_category
      f.input :price
      f.input :market_price
      f.input :keywords
      f.input :meaning
      f.input :status
      f.inputs "商品描述" do
  	  f.kindeditor :description,:allowFileManager => false
      end
    end
    f.actions
  end

  show do |menu|
    attributes_table do
      row :name
      row :credit
      row :product_category
      row :price
      row :market_price
      row :keywords
      row :meaning
      row :status
      row :description do
        raw(menu.description)
      end
    end
  end
end