#encoding:utf-8
ActiveAdmin.register Product  do
  menu :parent => "积分商城", :priority => 15
  member_action :set_tag, :method => :get do
    if(@product = Product.find_by_id(params[:id]))
      if @product.tag_list.include?(params[:tag])
        @product.tag_list.remove(params[:tag])
      else
        @product.tag_list.add(params[:tag])
      end
      @product.save
      flash[:notice] ="操作成功."
      redirect_to(:controller=>"/admin/products", :action=>:show,:id=>params[:id])
    else
      flash[:error] = "记录不存在."
      redirect_to(:controller=>"/admin/products", :action=>:index)
    end
  end
  member_action :add_tag, :method => :post do
    if(@product = Product.find_by_id(params[:id]))
      unless @product.tag_list.include?(params[:tag])
        @product.tag_list.add(params[:tag])
      end
      @product.save
      flash[:notice] ="操作成功."
      redirect_to(:controller=>"/admin/products", :action=>:show,:id=>params[:id])
    else
      flash[:error] = "记录不存在."
      redirect_to(:controller=>"/admin/products", :action=>:index)
    end
  end
  
  index do
    column :name
    column :credit
    column :price
    column :market_price
    column :keywords
    column :meaning
    column :status do |record|
      STATUS::STATUS_DATA["#{record.status}"]
    end
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
      f.input :status, :as=>:select,:collection=>STATUS::STATUS_DATA.invert, :required => true
      f.inputs "商品描述" do
        f.kindeditor :description,:allowFileManager => false
      end
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :name
      row :credit
      row :product_category
      row :price
      row :market_price
      row :keywords
      row :meaning
      row :status do
        STATUS::STATUS_DATA["#{record.status}"]
      end
      row :description do
        raw(record.description)
      end
      panel "所有标签" do
        Product.tag_counts.each do |tag|
          span :class => "action_item" do
            link_to "#{tag.name}", :controller => "/admin/products", :action => :set_tag,:id=>record.id,:tag=>tag.name
          end
        end
        form_for :product, :url=> add_tag_admin_product_path do |f|
          f.input "",:name=>"tag"
          f.submit "添加标签"
        end
      end
      panel "该商品的标签" do
        record.tag_list.each do |tag|
          "#{tag}"
        end
      end
    end
  end
end