require_relative '../lib/active_record'
require_relative './product'
require_relative './coupon'
require_relative './order_item'

#
# Class that will be used by data loader to load orders
#
class Order
  extend ActiveRecord

  validate(:id) { |id| id >= 0 }
  validate(:coupon_id) { |coupon_id| coupon_id.nil? || coupon_id >= 0 }

  def products
    OrderItem
      .all
      .select { |order_item| order_item.order_id == id }
      .map { |order_item| Product.find(order_item.product_id) }
  end

  def order_price_without_discount
    products.map(&:price).reduce(:+)
  end

  def progressive_discount
    case products.length
    when 0..1 then 0
    when 2..8 then 5 * products.length
    else 40
    end
  end

  def relative_discount!
    coupon = Coupon.find(coupon_id)
    return progressive_discount if coupon.nil?

    coupon_discount = coupon.relative_discount(order_price_without_discount)
    if coupon_discount > progressive_discount
      coupon.relative_discount(order_price_without_discount, mark_as_used: true)
    else
      progressive_discount
    end
  end

  def final_price!
    order_price_without_discount * (1 - relative_discount! / 100.0)
  end
end
