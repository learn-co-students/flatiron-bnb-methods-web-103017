class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.reservations.collect{|res| User.find(res.guest_id)}

  end

  def hosts
    self.trips.collect do |trip|
      User.find(trip.listing.host)
    end

  end

  def host_reviews
    self.reservations.collect{|res| res.review}
  end

end
