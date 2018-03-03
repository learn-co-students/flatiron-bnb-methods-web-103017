class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, :reservation, presence: true

  validate :checked_out, :reservation_accepted

  private

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "You cannot submit a review until your trips is over.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted and trip must be over to submit a review.")
    end
  end

end
