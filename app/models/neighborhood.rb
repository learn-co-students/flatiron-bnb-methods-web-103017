class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    checkin_date = Date.parse(checkin)
    checkout_date = Date.parse(checkout)
    self.listings.select do |listing|
      listing.available?(checkin_date, checkout_date)
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |neighborhood|
      listing_count = neighborhood.listings.count
      reservation_count = 0
      neighborhood.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      listing_count == 0? 0:(reservation_count.to_f/listing_count.to_f)
    end
  end

  def self.most_res
    self.all.max_by do |neighborhood|
      reservation_count = 0
      neighborhood.listings.each do |listing|
        reservation_count += listing.reservations.count
      end
      reservation_count
    end
  end
end
