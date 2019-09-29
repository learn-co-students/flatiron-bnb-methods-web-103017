class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"

  has_one :review

  validates :checkin, :checkout, presence: true
  validate :guest_and_host_not_the_same, :available_validate, :checkin_before_checkout

  def stay_range
    checkin...checkout
  end

  # Returns a duration
  def duration
    checkout - checkin
  end

  # calculates price based on the listing price and duration
  def total_price
    listing.price * duration
  end

  # Returns true if a given range falls outside of the the reservations checkin and checkout
  def available(start_date, end_date)
    (start_date...end_date).exclude?(stay_range) && start_date >= checkout
  end

  private

  def guest_and_host_not_the_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You can't book your own apartment")
    end
  end

  def available_validate
    # byebug
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |reservation|
      booked_dates = reservation.checkin..reservation.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates")
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkout <= checkin
      errors.add(:guest_id, "Your checkin date needs to be before your checkout date")
    end
  end

end
