require './adapters/data_loader'
require 'optparse'

usage_message = "Usage: ruby order_prices.rb csv cupons.csv products.csv orders.csv order_items.csv totals.csv"

OptionParser.new do |opts|
  opts.banner = usage_message
end.parse!

if ARGV.length != 6
  puts "Invalid arguments"
  puts usage_message
  exit 1
end

input_format = ARGV.shift.to_sym
output_file = ARGV.pop
files = ARGV

DataLoader.load(input_format, files)

CSV.open(output_file, "wb") do |csv|
  Order.all.each do |order|
    csv << [order.id, order.final_price!]
  end
end
