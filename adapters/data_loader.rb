require './models/coupon'
require './models/order_item'
require './models/order'
require './models/product'
require './lib/exceptions'
require './adapters/csv_adapter'

#
# O objetivo do DataLoader é fazer validações básicas e
# carregar os dados nos models
#
module DataLoader
  include CSVAdapter

  def self.load(input_format, sources)

    unless sources and sources.length == 4
      raise InvalidNumberOfInputSources
    end

    data = sources.map { |file| extract_lines(input_format, file) }

    load_data_into_model(Coupon, data[0], :id, :discount, :type, :expiration, :max_used)
    load_data_into_model(Product, data[1], :id, :price)
    load_data_into_model(Order, data[2], :id, :coupon_id)
    load_data_into_model(OrderItem, data[3], :order_id, :product_id)
  end

  private

    def self.extract_lines(input_format, filename)
      if input_format == :csv
        data = CSVAdapter.extract_lines(filename)
      else
        raise InvalidInputFormat
      end
    end

    def self.load_data_into_model(model, data, *columns)
      if data.nil? or data.length == 0
        raise EmptyDataSource.exception "#{model} has no data to be loaded"
      elsif data[0].length != columns.length
        msg = "#{model} columns and source columns does not match. Check the sources"
        raise InvalidDataSource.exception msg
      else
        model.load_data(data, *columns)
      end
    end

end
