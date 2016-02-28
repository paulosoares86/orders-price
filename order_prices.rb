require './adapters/data_loader'

example_msg = "Usage: ruby order_prices.rb csv coupons.csv products.csv orders.csv order_items.csv totals.csv"

if ARGV.length != 6
  puts "Invalid arguments"
  puts example_msg
  exit 1
end

input_format = ARGV.shift.to_sym
output_file = ARGV.pop
files = ARGV

DataLoader.load(input_format, *files)

CSV.open(output_file, "wb") do |csv|
  Order.all.each do |order|
    csv << [order.id, order.final_price!]
  end
end
