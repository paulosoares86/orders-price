require 'time'

#
# Reopen String class to add try_parse method
#
class String
  def try_parse
    case self
    when /^\d+$/ then to_i
    when /^[\d\.]+$/ then to_f
    when %r{^[\d\/]+$} then Time.parse(self)
    else self
    end
  end
end
