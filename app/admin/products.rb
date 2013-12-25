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

  member_action :delete_img, :method => :get do
    if(@product = Product.find_by_id(params[:id])) && (page_img = @product.product_imgs.find(params[:img_id]))
      if page_img.destroy
        flash[:notice] ="操作成功."
      else
        flash[:error] = "操作失败."
      end
      redirect_to(:controller=>"/admin/products", :action=>:show,:id=>params[:id])
    else
      flash[:error] = "记录不存在."
      redirect_to(:controller=>"/admin/products", :action=>:index)
    end
  end
  member_action :main_img, :method => :get do
    if(@product = Product.find_by_id(params[:id])) && (page_img = @product.product_imgs.find(params[:img_id]))
      if @product.update_attribute(:img_id, page_img.id)
        flash[:notice] ="操作成功."
      else
        flash[:error] = "操作失败."
      end
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
    column :merchant
    column :status do |record|
      Product::STATUS_DATA["#{record.status}"]
    end
    column :img do |obj|
      if obj.img.blank?
        raw "图片不存在"
      else
        raw "<img src='#{obj.img.public_filename(:tiny)}' />"
      end
    end
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "上传商品" do
      f.input :name
      f.input :merchant
      f.input :credit
      f.input :product_category,:as=>:select,:collection=> nested_set_options(ProductCategory){|i, level| "#{'-' * level} #{i.name}" },:include_blank=>'===请选择==='
      f.input :price
      f.input :market_price
      f.input :keywords
      f.input :description
      f.input :meaning
      f.input :status, :as=>:select,:collection=>Product::STATUS_DATA.invert, :required => true
      f.inputs "商品描述" do
        f.kindeditor :note,:allowFileManager => false
      end
      f.inputs "上传照片,建议比率800*800"  do
        f.has_many :product_imgs do |record|
          if !record.object.new_record?
            record.input :created_at, :as => :string, :input_html => {:disabled => true }
          end
          record.input :uploaded_data,:as=>:file
        end
      end
    end
    f.actions
  end

  show do |record|
    attributes_table do
      row :name
      row :merchant
      row :credit
      row :product_category
      row :price
      row :market_price
      row :keywords
      row :description
      row :meaning
      row :status do
        Product::STATUS_DATA["#{record.status}"]
      end
      row :note do
        raw(record.note)
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
      row :img do |obj|
        if obj.img.blank?
          raw "图片不存在"
        else
          raw "<img src='#{obj.img.public_filename(:tiny)}' />"
        end
      end
      div do
        br
        panel "产品图片" do
          table_for(record.product_imgs) do |t|
            t.column("图片") {|item| raw "<img src='#{item.public_filename(:tiny)}' />"}
            t.column("删除") {|item| link_to "删除" ,:action=>:delete_img,:id=>record.id,:img_id=>item.id}
            t.column("主图片") {|item| link_to "设置主图" ,:action=>:main_img,:id=>record.id,:img_id=>item.id}
          end
        end
      end
    end
  end
end