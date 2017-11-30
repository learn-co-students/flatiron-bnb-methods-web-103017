class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(d1, d2)
    result = []
    self.listings.each do |listing|
      array = []
      listing.reservations.each do |reservation|
        range = (DateTime.parse(d1)...DateTime.parse(d2))
        # is reservation outside range
        if !range.include?(reservation.checkin) && !range.include?(reservation.checkout)
          array << reservation
        end
      end
      result << listing if array.length == listing.reservations.length
     end
    result
  end

  def self.highest_ratio_res_to_listings
    ratio = 0
    city_value = nil
    self.all.each do |city|
      ratio_inst = city.total_reservations/city.total_listings
      if ratio_inst > ratio
        ratio = ratio_inst
        city_value = city
      end
    end
    city_value
  end

  def self.most_res
    result = 0
    city_value = nil
    self.all.each do |city|
      if city.total_reservations > result
        result = city.total_reservations.to_i
        city_value = city
      end
    end
    city_value
  end
  #amount of the reservation per listing
  def total_reservations
    self.listings.collect do |listing|
      listing.reservations.length
    end.first.to_f
  end

  #total number of listings per city
  def total_listings
    self.listings.length.to_f
  end

end
