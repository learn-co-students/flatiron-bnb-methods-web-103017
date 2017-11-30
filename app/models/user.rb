class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :foreign_key => 'guest_id', through: :reservations, :class_name => "User"
  #has_many :hosts, :foreign_key => 'host_id', through: :listings, :class_name => "User"

  def hosts
    self.trips.collect do |reservation|
      reservation.listing.host
    end.uniq
  end

  def host_reviews
    self.reservations.collect do |reservation|
      reservation.review
    end
  end
  
end
