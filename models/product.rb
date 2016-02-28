require_relative '../lib/active_record'

#
# Class that will be used by data loader to load products
#
class Product
  extend ActiveRecord

  validate(:id) { |id| id >= 0 }
  validate(:price) { |price| price >= 0 }
end
