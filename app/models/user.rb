class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
    self.reservations.collect do |res|
      User.find(res.guest_id)
    end
  end

  def hosts
    self.trips.collect do |res|
      User.find(res.listing.host_id)
    end
  end

  def host_reviews
    self.reservations.collect do |res|
      res.review
    end
  end
end
