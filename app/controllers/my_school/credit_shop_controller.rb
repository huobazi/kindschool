#encoding:utf-8
#积分商城
class MySchool::CreditShopController < MySchool::ManageController
  layout "credit_shop"
  before_filter :get_shop_config

  def index
   @tags = Product.tag_counts
  end

  def products
   @products = Product.search(params[:product] || {}).page(params[:page] || 1).per(25)
  end
  
  private
  def get_shop_config
    @logo = ShopConfig.find_by_number("logo")
  end
end
