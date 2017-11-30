class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  def available?(checkin, checkout)
    self.reservations.find do |reservation|
      reservation.checkin < checkout && reservation.checkout > checkin
    end
  end


end
