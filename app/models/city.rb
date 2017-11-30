class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

 def city_openings(datein, dateout)
    #takes a date range
    #finds listing within that range
    #outputs those listing
    openings = []
    self.listings.each do |listings|
      listings.reservations.each do |reservation|
        checkin = reservation.checkin
        checkout = reservation.checkout
        #binding.pry
        if [datein.to_date, checkin].max > [dateout.to_date, checkout].min
          openings << listings
        end
      end

     openings

   end
  end

 def self.highest_ratio_res_to_listings
    ratio = {}

   self.all.each do |city|
      listings = city.listings.count
      reservations = 0
      city.listings.each do |listing|
        reservations += listing.reservations.count
      end
      ratio[city] = (reservations.to_f/listings.to_f)

   end

   ratio.max_by{|k,v| v}[0]

 end

 def self.most_res
    ratio = {}

   self.all.each do |city|
      reservations = 0
      city.listings.each do |listing|
        reservations += listing.reservations.count
      end
      ratio[city] = (reservations)

   end

   ratio.max_by{|k,v| v}[0]

 end

end
