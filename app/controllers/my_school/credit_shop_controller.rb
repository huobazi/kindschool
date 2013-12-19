#encoding:utf-8
#积分商城
class MySchool::CreditShopController < MySchool::ManageController
  layout "credit_shop"
  before_filter :get_shop_config

  def index
    @tags = Product.tag_counts
  end

  def products
    @serarch_type = params[:serarch_type]
    if @serarch =  params[:serarch]
      case @serarch
      when "credit"
        then
        products = @serarch_type == "descend" ? Product.descend_by_credit : Product.ascend_by_credit
      when "price"
        then
        products = @serarch_type == "descend" ? Product.descend_by_price : Product.ascend_by_price
      end
    end
    @products = (products || Product).search(params[:product] || {}).where(:status=>2).page(params[:page] || 1).per(25)
  end

  
  def show_product
    @product = Product.find_by_id(params[:id])
    if @product
      @description = @product.description
      @keywords = @product.keywords
    end
  end
  
  def show_merchant
    @merchant = Merchant.find_by_id(params[:id])
    if @merchant
     @products = @merchant.products.where(:status=>2).order("updated_at DESC").limit(5)
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
    @items = @cart.items
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
    @order.order_infos << @cart.items
    @order.credit = @cart.total_credit
    @order.kindergarten = @kind
    @order.user = current_user
    if @order.save!
      @cart.empty!
      flash[:notice] = '下订单成功'
      redirect_to(:action=>'ship')
    else
      render(:action=>'checkout')
    end
  end

  def ship
    count = 0
    if things_to_ship = params[:to_be_shipped]
      count = do_shipping(things_to_ship)
        if count > 0
          count_text = pluralize(count, "order")
          flash.now[:notice] = "#{count_text} marked as shipped"
        end
    end
    @pending_orders = Order.pending_shipping
  end

  private
  def get_shop_config
    @logo = ShopConfig.find_by_number("logo")
  end

  def find_cart
    session[:cart] ||= Cart.new
  end
  
  def do_shipping(things_to_ship)
    count = 0
    things_to_ship.each do |order_id, do_it|
      if do_it == "yes"
        order = Order.find(order_id)
        order.mark_as_shipped
        order.save
        count += 1
      end
    end
    count
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
end
