class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation_id, presence:true

  validate :res_exists
  # validate :res_accepted
  validate :after_res

  def res_exists
    # binding.pry
    if !(self.reservation && self.reservation.status = "accepted")
      errors.add(:reservation, "can't be wrong")
    end
  end

  def after_res
    if self.created_at.nil?
    elsif !(self.created_at > self.reservation.checkout)
      errors.add(:reservation, "can't be wrong")
    end
  end


end
