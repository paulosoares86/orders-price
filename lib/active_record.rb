require_relative './string_parser'
require_relative './exceptions'
require_relative './csv'


module ActiveRecord
  attr_reader :all

  def find(id)
    all.find { |row| row.id == id }
  end

  def validate(field, &block)
    all.each do |instance|
      value = instance.send(field)
      unless yield(value)
        msg = "Error in #{self.name}: field #{field} can't be #{value}"
        raise InvalidCSV.exception msg
      end
    end
  end

  #
  # Transforma as linhas não vazias do csv em instancias da classe que estende
  # este módulo. Estas instancias podem ser acessadas através do reader all
  #
  def load_csv(filename, *columns)
    @all = []
    non_empty_rows = CSV.read_non_empty_lines(filename)
    columns.each_with_index do |col_name, col_index|
      attr_accessor(col_name)
      non_empty_rows.each_with_index do |row_values, row_index|
        value = row_values[col_index] && row_values[col_index].try_parse
        @all[row_index] = send(:new) if col_index == 0
        @all[row_index].send("#{col_name}=", value)
      end
    end
  end
end
