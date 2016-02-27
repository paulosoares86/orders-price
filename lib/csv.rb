require 'csv'

class CSV
  def self.read_non_empty_lines(filename)
    readlines(filename).select { |row| row.compact.length > 0 }
  end
end
