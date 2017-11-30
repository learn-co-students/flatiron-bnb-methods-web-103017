class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_exists_and_accepted_and_checkout_happened

  def reservation_exists_and_accepted_and_checkout_happened
    if !(self.reservation && self.reservation.status == 'accepted' && Time.now > self.reservation.checkout)
      self.errors[:base] << "Error"
    end
  end


end
