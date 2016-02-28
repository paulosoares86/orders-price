require './models/order'

Order.all.each do |order|
  puts "#{order.id},#{order.final_price!}"
end
