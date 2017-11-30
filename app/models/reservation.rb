class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :check_checkin
  validate :check_checkout
  validate :validate_host_is_not_guest
  validate :validate_available_at_checkin
  validate :validate_available_at_checkout
  validate :checkin_before_checkout
  validate :checkin_and_checkout_not_equal




  def check_checkin
    if !self.checkin.is_a?(Date)
      errors.add(:checkin, "Invalid date")
    end
  end

  def check_checkout
    if !self.checkout.is_a?(Date)
      errors.add(:checkout, "Invalide date")
    end
  end


  def validate_host_is_not_guest
    host = self.listing.host_id
    if self.guest_id == host
      errors.add(:guest_id, "Guest cannot be the host.")
    end
  end


  def validate_available_at_checkin
    self.listing.reservations.each do |reservation|
      if (reservation.checkin..reservation.checkout).include?(self.checkin)
        errors.add(:checkin, "Reservation time unavailable")
      end
    end
  end

  def validate_available_at_checkout
    self.listing.reservations.each do |reservation|
      if (reservation.checkin..reservation.checkout).include?(self.checkout)
        errors.add(:checkout, "Reservation time unavailable")
      end
    end
  end


  def checkin_before_checkout
    if !self.checkin.nil? && !self.checkout.nil?
      if self.checkout < self.checkin
        errors.add(:checkin, "Checkout must be after Checkin")
      end
    end
  end

  def checkin_and_checkout_not_equal
    if self.checkin == self.checkout
      errors.add(:checkin, "Checkin and Checkout cannot be the same")
      errors.add(:checkout, "Checkin and Checkout cannot be the same")
    end
  end

  def checkin_is_date
    if !self.checkin.is_a?(Date)
      errors.add(:checkin, "Checkin invalid")
    end
  end

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price

  end



end
