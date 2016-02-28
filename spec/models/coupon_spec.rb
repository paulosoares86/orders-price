require './spec/spec_helper'
require './adapters/data_loader'

describe Order do
  it 'should validate coupons' do
    expect(Coupon.find(345).valid?).to be_falsy
    expect(Coupon.find(567).valid?).to be_truthy
  end
end
