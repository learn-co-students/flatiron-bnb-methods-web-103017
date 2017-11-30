class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(start_date, end_date)

    date_range = (start_date.to_date..end_date.to_date)
    open_listings = self.listings.select do |listing|
      # if at any point a reservation is found then goodbye listing
      reservations_check = listing.reservations.reject do |res|
        #exclude any scenario where our reservation is unavailable
        date_range === (res.checkin) || date_range === (res.checkout)
      end
      listing.reservations.length == reservations_check.length
    end #end listings do
    open_listings
  end # end city_openings

  def self.highest_ratio_res_to_listings
    hash = {}
    Neighborhood.all.each do |hood|


      reservations_count = 0
      listings = hood.listings.count
      reservations = hood.listings.each do |listing|
        reservations_count += listing.reservations.count
      end

      if listings > 0
        hash[hood] = {reservations: reservations_count , listings: listings, ratio: reservations_count.to_f/listings.to_f}
      else
        hash[hood] = {reservations: 1 , listings: 1, ratio: 0}
      end
      # reservations = city.listings.each{|listing| listing.reservations}
    end
    hash
    # binding.pry
    winner = hash.sort_by{|k,v| v[:ratio]}.last.flatten.first

  end

  def self.most_res
    hash = {}
    Neighborhood.all.each do |hood|


      reservations_count = 0
      listings = hood.listings.count
      reservations = hood.listings.each do |listing|

        reservations_count += listing.reservations.count
      end
      hash[hood] = {reservations: reservations_count , listings: listings}
    end
    hash.sort_by{|k,v| v[:reservations]}.last.flatten.first
  end

end
