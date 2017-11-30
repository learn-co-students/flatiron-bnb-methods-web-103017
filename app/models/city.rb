class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    self.neighborhoods.collect do |neighborhood|
      neighborhood.neighborhood_openings(checkin, checkout)
    end.flatten
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |city|
      listing_count = city.listings.count
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservation_count.to_f/listing_count.to_f
    end
  end

  def self.most_res
    self.all.max_by do |city|
      reservation_count = 0
      city.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservation_count
    end
  end




end
