require './spec/spec_helper'
require './adapters/data_loader'

describe Order do
  it 'loads products' do
    expect(Order.find(345).products.map(&:id)).to eq [345, 876]
    expect(Order.find(123).products.map(&:id)).to eq [789, 987]
  end

  it 'calculates the correct total price' do
    expect(Order.find(123).order_price_without_discount).to eq 2500
  end

  it 'calculates the correct relative discount' do
    expect(Order.find(123).relative_discount!).to eq 10
    expect(Order.find(234).relative_discount!).to eq 15
    expect(Order.find(345).relative_discount!).to eq 15
  end

  it 'calculates the correct final price' do
    expect(Order.find(123).final_price!).to eq 2250
  end
end
