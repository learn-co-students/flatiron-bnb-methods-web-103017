class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

 def city_openings(datein, dateout)
    #takes a date range
    #finds listing within that range
    #outputs those listing
    #binding.pry
    all_listings = Hash.new(0)
    listings = Hash.new(0)
    openings = []

   self.listings.each do |listing|

     all_listings[listing] = 0
      listings[listing] = 0
      if listing != []
        listing.reservations.each do |reservation|
          #binding.pry
          checkin = reservation.checkin
          checkout = reservation.checkout
          all_listings[listing] += 1
          if [datein.to_date, checkin].max > [dateout.to_date, checkout].min
            listings[listing] += 1
          end
        end
      end
    end

   all_listings.each{|k,v| openings << k if listings[k] == v}

   openings

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

# class City < ActiveRecord::Base
#   has_many :neighborhoods
#   has_many :listings, :through => :neighborhoods
#
#  def city_openings(datein, dateout)
#     #takes a date range
#     #finds listing within that range
#     #outputs those listing
#     openings = []
#     self.listings.each do |listings|
#       listings.reservations.each do |reservation|
#         checkin = reservation.checkin
#         checkout = reservation.checkout
#         #binding.pry
#         if [datein.to_date, checkin].max > [dateout.to_date, checkout].min
#           openings << listings
#         end
#       end
#
#      openings
#
#    end
#   end
#
#  # def self.highest_ratio_res_to_listings
#  #    ratio = {}
#  #
#  #   self.all.each do |city|
#  #      listings = city.listings.count
#  #      reservations = 0
#  #      city.listings.each do |listing|
#  #        reservations += listing.reservations.count
#  #      end
#  #      ratio[city] = (reservations.to_f/listings.to_f)
#  #
#  #   end
#  #
#  #   ratio.max_by{|k,v| v}[0]
#  #
#  # end
#  #
#  # def self.most_res
#  #    ratio = {}
#  #
#  #   self.all.each do |city|
#  #      reservations = 0
#  #      city.listings.each do |listing|
#  #        reservations += listing.reservations.count
#  #      end
#  #      ratio[city] = (reservations)
#  #
#  #   end
#  #
#  #   ratio.max_by{|k,v| v}[0]
#  #
#  # end
#
# end
