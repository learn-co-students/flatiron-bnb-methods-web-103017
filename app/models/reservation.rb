class Reservation < ActiveRecord::Base

  include

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :own_listing
  validate :available?

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  def available?

    # binding.pry
    test_array = []

    if self.checkin.blank? || self.checkout.blank? || self.checkin >= self.checkout
      errors.add(:checkin, "can't be invalid")
    else
      self.listing.reservations.each do |reservation|
        if (reservation.checkin >= self.checkout || reservation.checkout <= self.checkin) == true
          test_array << true
        else
          test_array << false
        end
      end
      if test_array.include?(false)
        errors.add(:checkin, "can't be invalid")
      end
    end
  end



  def own_listing

    # if the guest on the res == host of the listing
    # binding.pry
    if self.guest_id == self.listing.host_id
      errors.add(:guest_id, "can't be same as host id")
    end

  end

end
