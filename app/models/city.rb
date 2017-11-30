class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)

    date_range = (start_date.to_date..end_date.to_date)

    open_listings = self.listings.select do |listing|
      # if at any point a reservation is found then goodbye listing
      reservations_check = listing.reservations.reject do |res|
        #exclude any scenario where our reservation is unavailable
        date_range === (res.checkin) || date_range === (res.checkout)
      end
      listing.reservations.length == reservations_check.length

      # listing unless listing.reservations.any?{|reservation| date_range.include?(reservation.checkin) || date_range.include?(reservation.checkout)}

    # listings= self.listings.select do |listing|
    #   listing unless listing.reservations.any?{|reservation|date_range.include?(reservation.checkin) || date_range.include?(reservation.checkout)}
    end #end listings do
    open_listings


  end # end city_openings


  def self.highest_ratio_res_to_listings
    hash = {}
    City.all.each do |city|


      reservations_count = 0
      listings = city.listings.count
      reservations = city.listings.each do |listing|

        reservations_count += listing.reservations.count
      end
      hash[city] = {reservations: reservations_count , listings: listings, ratio: (reservations_count.to_f/listings.to_f)}
      # reservations = city.listings.each{|listing| listing.reservations}

    end

    winner = hash.sort_by{|k,v| v[:ratio]}.last.flatten.first
  end

  def self.most_res
    hash = {}
    City.all.each do |city|


      reservations_count = 0
      listings = city.listings.count
      reservations = city.listings.each do |listing|

        reservations_count += listing.reservations.count
      end
      hash[city] = {reservations: reservations_count , listings: listings}
    end
    hash.sort_by{|k,v| v[:reservations]}.last.flatten.first
  end

end
