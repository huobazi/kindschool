#encoding:utf-8
#购物车
class Cart
 attr_reader :items
 attr_reader :total_price

 def initialize
 	empty!
 end

 def add_product(product)
   item = @items.find {|i| i.product_id == product.id} if @items
   if item
    item.count += 1
   else
    item = OrderInfo.for_product(product)
    @items << item unless @items.nil?
   end
    @total_price += product.price if @total_price
 end
 def empty!
 	@items = []
 	@total_price = 0.0
  end
end