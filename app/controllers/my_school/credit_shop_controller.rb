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
        puts "=========0"
        products = @serarch_type == "descend" ? Product.descend_by_credit : Product.ascend_by_credit
      when "price"
        then
        puts "=========1"
        products = @serarch_type == "descend" ? Product.descend_by_price : Product.ascend_by_price
      end
    end
    @products = (products || Product).search(params[:product] || {}).page(params[:page] || 1).per(25)
  end
  
  private
  def get_shop_config
    @logo = ShopConfig.find_by_number("logo")
  end
end
