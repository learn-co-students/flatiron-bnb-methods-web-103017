class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :trip_over?




  def trip_over?
    if reservation && reservation.checkout > Date.today
      errors.add(:reservation, "Invalid")
    end
  end


end
