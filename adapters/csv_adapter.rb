require 'csv'

module CSVAdapter

  def self.extract_lines(filename)
    if filename.nil? or not File.exist?(filename)
      raise EmptyDataSource
    end
    CSV.readlines(filename).select { |row| row.compact.length > 0 }
  end
  
end
