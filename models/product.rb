require_relative '../lib/active_record'

class Product
  extend ActiveRecord

  validate(:id) { |id| id >= 0 }
  validate(:price) { |price| price >= 0 }
end
