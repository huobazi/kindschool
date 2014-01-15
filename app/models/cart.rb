#encoding:utf-8
#购物车
class Cart
  attr_reader :items
  attr_reader :total_credit

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
    # @total_price += product.price if @total_price
    @total_credit += product.credit if @total_credit
  end

  def delete_product(product)
    item = @items.find {|i| i.product_id == product.id} if @items
    if item
      @total_credit -= product.credit if @total_credit
      @items.delete(item)
    end
  end

  def find_by_id(ids)
    items = @items.find_all {|i| ids.include?(i.product_id.to_s)}
    return items
  end
 
  def empty!
    @items = []
    @total_credit = 0.0
  end
  
end