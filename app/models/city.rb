class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(d1, d2)
    self.listings.select do |listing|
      # needs a select method
    #   listing.reservations.collect do |reservation|
    #     range = (DateTime.parse(d1)...DateTime.parse(d2))
    #     !range.include?(reservation.checkin) && !range.include?(reservation.checkout)
    #   end
    # end
  end
end

  #will return a boolean
  def date_range_check(d1, d2)
    range = (DateTime.parse(d1)...DateTime.parse(d2))
    !range.include?(reservation.checkin) && !range.include?(reservation.checkout)
  end

  #needs to return only if the collection is all 'true' booleans
  def reservations_check(d1, d2)
    self.reservations.collect do |reservation|
      if reservation.date_range_check(d1, d2) ==
    end
  end

  def opening_check

  end
