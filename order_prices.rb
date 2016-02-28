require './adapters/data_loader'

if ARGV.length != 6
  puts 'Invalid arguments'
  puts 'Usage: ruby order_prices.rb csv coupons.csv products.csv' \
                                      ' orders.csv order_items.csv totals.csv'
  exit 1
end

input_format = ARGV.shift.to_sym
output_file = ARGV.pop
DataLoader.load(input_format, *ARGV)

CSV.open(output_file, 'wb') do |csv|
  Order.all.each do |order|
    csv << [order.id, order.final_price!]
  end
end
