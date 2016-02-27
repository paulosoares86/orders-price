require_relative '../lib/active_record'

class OrderItem
  extend ActiveRecord
  load_csv './files/order_items.csv', :order_id, :product_id

  validate(:order_id) { |order_id| order_id >= 0 }
  validate(:product_id) { |product_id| product_id >= 0 }
  
end
