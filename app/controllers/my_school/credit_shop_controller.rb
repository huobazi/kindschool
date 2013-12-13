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
    @products = (products || Product).search(params[:product] || {}).page(params[:page] || 1).per(25)
  end

  
  def show_product
   @product = Product.find_by_id(params[:id])
  end
  
  #添加购物车
  def add_to_cart
    product = Product.find(params[:id])
    @cart = find_cart
    @cart.add_product(product)
    redirect_to(:action => 'display_cart')
   rescue
     logger.error("Attempt to access invalid product #{params[:id]}")
　　 flash[:notice] = '无效商品'
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
     redirect_to_index("There's nothing in your cart!")
    else
     @order = Order.new
    end
  end
  
  def save_order
    
  end

  private
  def get_shop_config
    @logo = ShopConfig.find_by_number("logo")
  end

  def find_cart
    session[:cart] ||= Cart.new
  end
end
