require_relative '../lib/active_record'

require 'time'

#
# Class that will be used by data loader to load coupons
#
class Coupon
  extend ActiveRecord

  validate(:id) { |id| id >= 0 }
  validate(:discount) { |discount| discount >= 0 }
  validate(:type) { |type| type == 'absolute' || type == 'percent' }
  validate(:expiration) { |expiration| expiration.is_a? Time }
  validate(:max_used) { |max_used| max_used >= 0 }

  def valid?
    @used_count ||= 0
    @used_count < max_used && Time.now < expiration
  end

  def relative_discount(price, mark_as_used: false)
    if valid? && price > 0
      @used_count += 1 if mark_as_used
      type == 'percent' ? discount : discount * 100.0 / price
    else
      0
    end
  end
end
