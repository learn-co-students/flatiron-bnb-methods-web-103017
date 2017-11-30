class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review


  validate :own_listing, :checkin_checkout_checks, :availability


  def own_listing
    if self.listing.host_id == self.guest_id
      errors.add(:guest, "Cannot make a reservation on your own listing")
    end
  end

  def checkin_checkout_checks
    if self.checkin.nil? || self.checkout.nil?
      errors.add(:checkin, "Cannot have nil checkin or checkout")
      return
    end
    if self.checkin > self.checkout
      errors.add(:checkin, "Checkin must be before checkout")
      return
    end
    if self.checkin == self.checkout
      errors.add(:checkin, "Checkin must be different than checkout")
    end
  end

  def availability
    conflict = self.listing.reservations.find do |reservation|
      (reservation.checkin...reservation.checkout).include?(self.checkin) || (reservation.checkin...reservation.checkout).include?(self.checkout)
    end

    if conflict != nil
      errors.add(:checkin, "Checkin or Checkout Invalid")
    end
  end

  def duration
    (self.checkin...self.checkout).count
  end

  def total_price
    self.duration * self.listing.price
  end



























end
