class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    master_arr = []
    self.listings.each do |listing|
      arr = []
      listing.reservations.each do |res|
        if res.checkout <= start_date.to_date || res.checkin >= end_date.to_date
          arr << true
        else
          arr << false
        end
      end
      if !arr.include?(false)
        master_arr << listing
      end
    end
    master_arr
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_city = ""
    self.all.each do |city|
      listings = city.listings.collect{|listing| listing}
      reservations = city.listings.collect{|listing| listing.reservations}.flatten!
      ratio = reservations.count.to_f/listings.count.to_f
      if ratio > highest_ratio || highest_ratio == 0
        highest_ratio = ratio
        highest_city = city
      end
    end
    highest_city
  end

  def self.most_res
    most_reservations = 0
    city_most_res = ""
    self.all.each do |city|
      reservations = city.listings.collect{|listing| listing.reservations}.flatten!.count
      if reservations > most_reservations
        most_reservations = reservations
        city_most_res = city
      end
    end
    city_most_res
  end

end
