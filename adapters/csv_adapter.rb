require 'csv'

#
# Implements the CSV Adapter to extract non empty rows from CSVs
#
module CSVAdapter
  def self.extract_lines(filename)
    raise EmptyDataSource if filename.nil? || !File.exist?(filename)
    CSV.readlines(filename).select { |row| !row.compact.empty? }
  end
end
