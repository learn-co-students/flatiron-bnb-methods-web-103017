class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(datein, dateout)
    available_listings = []
    self.listings.each do |listings|
      available = true
      listings.reservations.each do |reservation|

        checkin = reservation.checkin
        checkout = reservation.checkout
        #binding.pry
        if [datein.to_date, checkin].max < [dateout.to_date, checkout].min
          available = false
        end
      end
      if available == true
        available_listings << listings
      end
    end
    available_listings
  end

  def self.highest_ratio_res_to_listings
     ratio = {}

    self.all.each do |city|
       listings = city.listings.count
       reservations = 0
       city.listings.each do |listing|
         reservations += listing.reservations.count
       end
       if reservations != 0 && listings != 0
         ratio[city] = (reservations.to_f/listings.to_f)
       end
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
