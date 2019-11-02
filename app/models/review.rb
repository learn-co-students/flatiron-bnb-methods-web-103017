require "time"
class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"
  validates :rating, presence: true
  validates :description, presence: true
  validate :checked_out, :reservation_accepted

  # def reservation_valid
  #   if self.reservation.status == "accepted" || !(Date.today > reservation.checkout)
  #     errors.add(:review, "Your reservation status does not allow you to review.")
  #   end
  # end

  def checked_out
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Reservation must have ended to leave a review.")
    end
  end

  def reservation_accepted
    if reservation.try(:status) != 'accepted'
      errors.add(:reservation, "Reservation must be accepted to leave a review.")
    end
  end


end
