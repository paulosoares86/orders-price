require './models/coupon'
require './models/order_item'
require './models/order'
require './models/product'
require './lib/exceptions'
require './adapters/csv_adapter'

#
# O objetivo do DataLoader é fazer validações básicas e
# carregar os dados nos models. Outras fontes de dados diferentes de CSV
# podem ser incluídas neste módulo.
#
module DataLoader
  include CSVAdapter

  def self.load(input_format, coupon_source, product_source, order_source, order_item_source)
    load_data_into_model(:csv, Coupon, coupon_source, :id, :discount, :type, :expiration, :max_used)
    load_data_into_model(:csv, Product, product_source, :id, :price)
    load_data_into_model(:csv, Order, order_source, :id, :coupon_id)
    load_data_into_model(:csv, OrderItem, order_item_source, :order_id, :product_id)
  end

  private

    def self.load_data_into_model(input_format, model, source, *columns)
      data = extract_lines(input_format, source)
      if data.nil? or data.length == 0
        msg = "#{source} has no data to be loaded into #{model}."
        raise EmptyDataSource.exception
      elsif data[0].length != columns.length
        msg = "#{model} and source number of columns does not match."
        raise InvalidDataSource.exception msg
      end
      model.load_data(data, *columns)
    end

    def self.extract_lines(input_format, source)
      if input_format == :csv
        data = CSVAdapter.extract_lines(source)
      else
        raise InvalidInputFormat
      end
    end

end
