require './spec/spec_helper'
require './adapters/data_loader'
require './lib/exceptions'

describe DataLoader do
  describe '#load' do
    let(:files) do
      [
        './spec/files/coupons.csv',
        './spec/files/products.csv',
        './spec/files/orders.csv',
        './spec/files/order_items.csv'
      ]
    end

    describe 'validation' do
      it 'throws error when user provides more input sources than required' do
        expect { DataLoader.load(:csv, *Array.new(5)) }
          .to raise_error(ArgumentError)
      end

      it 'throws error when user provides less input sources than required' do
        expect { DataLoader.load(:csv, *Array.new(3)) }
          .to raise_error(ArgumentError)
      end

      it 'throws error when user provides some empty input source' do
        expect { DataLoader.load(:csv, *Array.new(4)) }
          .to raise_error(EmptyDataSource)

        invalid_files = files.dup
        invalid_files[3] = './spec/files/empty_orders.csv'
        expect { DataLoader.load(:csv, *invalid_files) }
          .to raise_error(EmptyDataSource)
      end

      it 'throws error when user provides input sources that doesn\'t exist' do
        invalid_files = files.dup
        invalid_files[3] = 'filethatdoesnotexist'
        expect { DataLoader.load(:csv, *invalid_files) }
          .to raise_error(EmptyDataSource)
      end

      it 'throws error when input sources has wrong number of columns' do
        invalid_files = files.dup
        invalid_files[3] = files[0]
        invalid_files[0] = files[3]
        expect { DataLoader.load(:csv, *invalid_files) }
          .to raise_error(InvalidDataSource)
      end
    end

    it 'loads data into models when sources are ok' do
      DataLoader.load(:csv, *files)
      expect(Product.all.length).to eq 10
    end
  end
end
