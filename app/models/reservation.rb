class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :not_own_listing
  validate :available
  validate :checkin_before_checkout

  def not_own_listing
    if self.listing.host == self.guest
      self.errors[:base] << "Can't reserve your own property"
    end
  end

  def available
    #yay for short circuit evaluation
    if self.checkin && self.checkout && !self.listing.available?(self.checkin, self.checkout)
      self.errors[:base] << "The property is unavailable for these dates"
    end
  end

  def checkin_before_checkout
    if self.checkin && self.checkout && self.checkout <= self.checkin
      self.errors[:base] << "Please choose a checkin date at least one day before checkout"
    end
  end

end
