require_relative '../models/product'
require_relative '../models/order'
require_relative '../models/coupon'
require 'test/unit'

class TestActiveRecord < Test::Unit::TestCase

  def test_loading_product
    assert_equal(150.0, Product.find(123).price)
    assert_equal(225.0, Product.find(234).price)
  end

  def test_order_products
    assert_equal([345, 876], Order.find(345).products.map(&:id))
    assert_equal([789, 987], Order.find(123).products.map(&:id))
  end

  def test_order_total_price
    assert_equal(2500, Order.find(123).total_price)
  end

  def test_coupon_valid
    assert_equal(false, Coupon.find(345).valid?)
    assert_equal(true, Coupon.find(567).valid?)
  end

  def test_discount
    assert_equal(10, Order.find(123).relative_discount!)
    assert_equal(15, Order.find(234).relative_discount!)
    assert_equal(15, Order.find(345).relative_discount!)
  end

  def test_final_price
    assert_equal(2250, Order.find(123).final_price!)
  end
end
