class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'



  def guests
    result_arr = []
    self.listings.each do |listing|
      listing.reservations.select do |reservation|
        result_arr << reservation.guest
      end
    end
    result_arr
  end

  def hosts
    self.trips.collect do |trip|
      trip.listing.host
    end
  end
  
  def host_reviews
    result_arr = []
    self.listings.each do |listing|
      listing.reservations.each do |reservation|
        result_arr << reservation.review
      end
    end
    result_arr
  end

end
