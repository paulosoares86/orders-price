require './lib/string'
require './lib/exceptions'

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

  #
  # Recebe uma matriz de dados e uma lista de colunas.
  # Cada linha da matriz é transformada em uma instância da classe que extende
  # este módulo.
  #
  def load_data(rows, *columns)
    @all = []
    columns.each_with_index do |col_name, col_index|
      attr_accessor(col_name)
      rows.each_with_index do |row_values, row_index|

        # Faz o parse do valor da célula caso esteja em um formato conhecido
        # como data, int ou float. Caso o formato seja desconhecido, value
        # permanece como string
        value = row_values[col_index] && row_values[col_index].try_parse

        # cria uma nova instância da classe para cada linha
        @all[row_index] ||= send(:new)
        instance = @all[row_index]

        # seta o valor da propriedade para o valor parseado
        instance.send("#{col_name}=", value)

        # checa se o valor fornecido é valido
        validate_field(instance, col_name)
      end
    end
  end

  private

    def validate_field(instance, field)
      return if @validations.nil? or @validations[field].nil?
      @validations[field].each do |validation|
        value = instance.send(field)
        unless validation.call(value)
          msg = "Error in #{self.name}: field #{field} can't be #{value}"
          raise InvalidInput.exception msg
        end
      end
    end

end
