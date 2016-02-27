require_relative '../lib/active_record'

class Product
  extend ActiveRecord
  load_csv './files/products.csv', :id, :price

  validate(:id) { |id| id >= 0 }
  validate(:price) { |price| price >= 0 }
end
