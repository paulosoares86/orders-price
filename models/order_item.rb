require_relative '../lib/active_record'

#
# Class that will be used by data loader to load order items
#
class OrderItem
  extend ActiveRecord

  validate(:order_id) { |order_id| order_id >= 0 }
  validate(:product_id) { |product_id| product_id >= 0 }
end
