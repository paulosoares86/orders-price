require './models/coupon'
require './models/order_item'
require './models/order'
require './models/product'
require './lib/exceptions'
require './adapters/csv_adapter'

#
# The objective of this module is to perform basic validations and
# load data into models. Other data sources can be included on this module.
#
module DataLoader
  include CSVAdapter

  def self.load(input_format, coupon_source, product_source, order_source,
                order_item_source)
    load_data_into_model(input_format, Coupon, coupon_source, :id, :discount,
                         :type, :expiration, :max_used)
    load_data_into_model(input_format, Product, product_source, :id, :price)
    load_data_into_model(input_format, Order, order_source, :id, :coupon_id)
    load_data_into_model(input_format, OrderItem, order_item_source,
                         :order_id, :product_id)
  end

  def self.load_data_into_model(input_format, model, source, *columns)
    data = extract_lines(input_format, source)
    if data.nil? || data.empty?
      msg = "#{source} has no data to be loaded into #{model}."
      raise EmptyDataSource.exception msg
    elsif data[0].length != columns.length
      msg = "#{model} and source number of columns does not match."
      raise InvalidDataSource.exception msg
    end
    model.load_data(data, *columns)
  end

  # other data sources formats can be added here
  def self.extract_lines(input_format, source)
    raise InvalidInputFormat if input_format != :csv
    CSVAdapter.extract_lines(source)
  end
end
