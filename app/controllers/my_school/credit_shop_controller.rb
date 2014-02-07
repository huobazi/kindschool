#encoding:utf-8
#积分商城
class MySchool::CreditShopController < MySchool::ManageController

  layout "shop_center"
  
  before_filter :get_shop_config

  def index
    @tags = Product.tag_counts
    @product_categories = []
    # ProductCategory.roots.each do |n|
    #   n.self_and_descendants.each_with_level do |item, level|
    #     item[:lvl] = level
    #     @product_categories << item
    #   end
    # end
    @count = cart_count
    render :layout =>"credit_shop"
  end

  def my_order
    @personal_credits = current_user.personal_credit
    @un_orders = current_user.orders.pending_shipping
    @en_orders = current_user.orders.where("shipment_at is not null")
  end

  def credit_activity
  end

  def get_credit
  end

  def products
    @serarch_type = params[:serarch_type]
    @personal_credits = current_user.personal_credit
    if @serarch =  params[:serarch]
      case @serarch
      when "credit"
        then
        products = @serarch_type == "descend" ? Product.descend_by_credit : Product.ascend_by_credit
      when "price"
        then
        products = @serarch_type == "descend" ? Product.descend_by_price : Product.ascend_by_price
      when "tag"
        then
        products = Product.tagged_with(@serarch_type).by_join_date
      when "user_credit"
        then 
        products = Product.user_credit(current_user.personal_credit.credit) if current_user.personal_credit
      end
    end
    @count = cart_count
    @products = (products || Product).search(params[:product] || {}).where(:status=>2,:shop_id=>@shop_tp).page(params[:page] || 1).per(9)
  end

  
  def show_product
    @product = Product.find_by_id_and_shop_id(params[:id],@shop_tp)
     @count = cart_count
    if @product
      @description = @product.description
      @keywords = @product.keywords
    end
  end

  # 用户个人信息
  def user_center
    @personal_credits = current_user.personal_credit
    @un_orders = current_user.orders.pending_shipping
    @en_orders = current_user.orders.where("shipment_at is not null")
  end
  
  def show_merchant
    @merchant = Merchant.find_by_id(params[:id])
    if @merchant
      @products = @merchant.products.where(:status=>2,:shop_id=>@shop_tp).order("updated_at DESC").limit(5)
    end
  end
  
  #添加购物车
  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.add_product(product)
    redirect_to(:action => 'display_cart')
  rescue
    logger.error("Attempt to access invalid product #{params[:id]}")
    flash[:notice] = "无效商品"
    redirect_to(:action => 'products')
  end
  #删除购物车中某个商品
  def delete_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.delete_product(product)
    redirect_to(:action => 'display_cart')
  rescue
    logger.error("Attempt to access invalid product #{params[:id]}")
    flash[:notice] = "无效商品"
    redirect_to(:action => 'products')
  end

  def display_cart
    @cart = find_cart
    @items = @cart.items
  end

  def empty_cart
    find_cart.empty!
    flash[:notice] = 'Your cart is now empty'
    redirect_to(:action => 'display_cart')
  end
  
  def checkout
    @cart = find_cart
    #    @items = @cart.items
    @items = @cart.find_by_id(params[:ids])
    @total_credit = @items.sum{|record| record.product.credit * record.count }
    if @items.empty?
      redirect_to(:action=>"index")
    else
      @order = Order.new
      @order.number=Time.now.to_i.to_s + rand(100).to_s
    end
  end
  
  def save_order
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.number=Time.now.to_i.to_s + rand(100).to_s
    @items = @cart.find_by_id(params[:ids])
    @order.order_infos << @items
    @total_credit = @items.sum{|record| record.product.credit * record.count }
    @order.credit = @total_credit
    @order.kindergarten = @kind
    @order.user = current_user
    if @order.save!
      ids = @items.collect(&:product_id)
      ids.each do |product_id|
        product = Product.find(product_id)
        @cart.delete_product(product)
      end
      flash[:notice] = '下订单成功'
      redirect_to(:action=>'ship')
    else
      render(:action=>'checkout')
    end
  end

  def ship
    count = 0
    products = []
    if things_to_ship = params[:to_be_shipped]
      count,products = do_shipping(things_to_ship)
      if count > 0
        count_text = pluralize(count, "order")
        flash.now[:notice] = "#{count_text} 已经成功扣除积分并进行配送"
      end
      unless products.blank?
        flash[:notice] = "#{products.collect{|x|x.name}}没有库存了."
      end
    end
    @pending_orders = current_user.orders.pending_shipping unless current_user.orders.blank?
  end

  def show_product_categories
    category_id = params[:group_id]
    product_category = ProductCategory.find(category_id.to_i) 
    @products=product_category.products.page(params[:page] || 1).per(25)
    render :partial =>"show_product_categories"
  end

  private
  def get_shop_config
    @logo = ShopConfig.find_by_number("logo")
    @shop_tp = current_user.tp == 0 ? 0 : 1 #如果是0表示学生商城，如果是1表示幼儿园商城
  end

  def find_cart
    session[:cart] ||= Cart.new
  end
  
  def do_shipping(things_to_ship)
    count = 0
    products=[]
    things_to_ship.each do |order_id, do_it|
      if do_it == "yes"
        order = Order.find(order_id)
        #判断是否库存够了
        if order.product_storage_able.blank?
          order.product_storage_off
          order.mark_as_shipped
          order.save
          count += 1
        else
          products << order.product_storage_able
        end
      end
    end
    return count,products
  end
 
  def pluralize(count, noun)
    if 0 == count
      "No #{noun.pluralize}"
    elsif 1 == count
      "One #{noun}"
    else
      "#{count} #{noun.pluralize}"
    end
  end
  
  def cart_count
   @cart = find_cart
    count = 0
    (@cart.items||[]).each do |item|
       count += item.count
    end 
    count
  end
end
