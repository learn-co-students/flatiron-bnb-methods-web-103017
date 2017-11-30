class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    # binding.pry
    self.listings.collect do |listing|
      listing.guests
    end.flatten
  end

  def hosts
    self.trips.collect do |reservation|
      reservation.listing.host
    end
  end

  def host_reviews
    self.listings.collect do |listing|
      listing.reservations.collect do |reservation|
        reservation.review
      end
    end.flatten
  end

end
