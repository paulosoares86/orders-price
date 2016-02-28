require 'time'

class String
  def try_parse
    case self
    when /^\d+$/ then self.to_i
    when /^[\d\.]+$/ then self.to_f
    when /^[\d\/]+$/ then Time.parse(self)
    else self
    end
  end
end
