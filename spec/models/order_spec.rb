require './spec/spec_helper'
require './adapters/data_loader'

describe Order do

  # def test_loading_product
  #   assert_equal(150.0, Product.find(123).price)
  #   assert_equal(225.0, Product.find(234).price)
  # end
  #
  # def test_order_products
  #   assert_equal([345, 876], Order.find(345).products.map(&:id))
  #   assert_equal([789, 987], Order.find(123).products.map(&:id))
  # end
  #
  # def test_coupon_valid
  #   assert_equal(false, Coupon.find(345).valid?)
  #   assert_equal(true, Coupon.find(567).valid?)
  # end

  it "calculates the correct total price" do
    expect(Order.find(123).total_price).to eq 2500
  end


  it "calculates the correct relative discount" do
    expect(Order.find(123).relative_discount!).to eq 10
    expect(Order.find(234).relative_discount!).to eq 15
    expect(Order.find(345).relative_discount!).to eq 15
  end

  it "calculates the correct final price" do
    expect(Order.find(123).final_price!).to eq 2250
  end

end
