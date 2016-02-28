require './lib/string'
require './lib/exceptions'

#
# When this module extends some class, the class will be able to
# map a matrix of data into an array of instances of the class using method
# load_data:
#
#   data = [['1', 'product1'], ['2', 'product2']]
#   Product.load_data(data, :id, :name)
#
# This array can be fetched using all accessor:
#
#   Product.all
#   # => [#<Product:0x007fcb2b886488 @id=123, @price=150.0>, ...]
#
# In order to find a record with a given id, the class method find can be used:
#
#   Product.find(123)
#   # => #<Product:0x007fcb2b886488 @id=123, @price=150.0>
#
module ActiveRecord
  attr_reader :all, :validations

  def find(id)
    all.find { |row| row.id == id }
  end

  def validate(field, &block)
    @validations ||= {}
    @validations[field] ||= []
    @validations[field] << block
  end

  # Receives a data matrix and list of column names.
  # Each line of matrix is mapped to a instance of the extending class.
  def load_data(rows, *columns)
    @all = []
    columns.each_with_index do |col_name, col_index|
      attr_accessor(col_name)
      rows.each_with_index do |row_values, row_index|
        value = parse_value_from_source(col_name, row_values[col_index])
        set_value_instance(row_index, col_name, value)
      end
    end
  end

  private

  def validate_field(field, value)
    return if @validations.nil? || @validations[field].nil?
    @validations[field].each do |validation|
      unless validation.call(value)
        msg = "Error in #{self.class.name}: field #{field} can't be #{value}"
        raise InvalidInput.exception msg
      end
    end
  end

  # Creates a new instance of extending class for each line
  # and sets instance's attribute named col_name to the parsed value
  def set_value_instance(row_index, col_name, value)
    @all[row_index] ||= send(:new)
    @all[row_index].send("#{col_name}=", value)
  end

  # If the format of the string is known (int, float or date) it will be parsed,
  # else it will return the original string.
  # If parsed value does not pass provided validations an exception will be
  # thrown
  def parse_value_from_source(col_name, source_data)
    value = source_data && source_data.try_parse
    validate_field(col_name, value)
    value
  end
end
