class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true

  validate :exists

  def exists
    if self.reservation.nil?
      return errors[:base] << "No reservation exists for this review"
    end
    if self.reservation.status == "accepted"
      unless self.reservation.checkout < Time.now
        return errors[:base] << "Checkout has not yet happened"
      end
    else
      errors[:base] << "Reservation has not been accepted"
    end
  end

end
