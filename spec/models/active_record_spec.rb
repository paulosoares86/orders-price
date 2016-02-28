require './spec/spec_helper'
require './lib/active_record'

class TestModel
  extend ActiveRecord
  validate(:id) { |id| id > 0 }
end

describe ActiveRecord do
  describe "data loading" do
    before do
      TestModel.load_data([['1', 'paulo'], ['2', 'soares']], :id, :name)
    end

    it "should map column values to instances" do
      expect(TestModel.all.length).to eq 2
      expect(TestModel.all.last.id).to eq 2
      expect(TestModel.all.first.name).to eq 'paulo'
    end

    it "should allow instances to be found" do
      expect(TestModel.find(2).name).to eq 'soares'
    end

    describe "validation" do

      it "allow empty fields when there are no constraints" do
        TestModel.load_data([['1', nil], ['2', nil]], :id, :name)
      end

      it "throws an exception when invalid values are provided" do
        expect{
          TestModel.load_data([['0', nil], ['2', nil]], :id, :name)
        }.to raise_error(InvalidInput)
      end

    end

  end
end
