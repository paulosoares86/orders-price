require 'csv'
require './spec/spec_helper'
require './adapters/data_loader'

describe 'Main application output' do
  let(:files) do
    [
      './spec/files/coupons.csv',
      './spec/files/products.csv',
      './spec/files/orders.csv',
      './spec/files/order_items.csv'
    ]
  end

  it 'should produce results that match with output.csv' do
    DataLoader.load(:csv, *files)
    expected = CSV.readlines('./spec/files/output.csv')
    Order.all.each_with_index do |order, index|
      expect(order.id.to_s).to eq expected[index][0]
      expect(order.final_price!).to eq expected[index][1].to_f
    end
  end
end
