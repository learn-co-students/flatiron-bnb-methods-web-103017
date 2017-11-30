class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true

  before_create :change_host_status_to_true
  before_destroy :change_host_status_to_false

  def available?(checkin, checkout)
    available = true
    self.reservations.each do |reservation|
      available = false if (reservation.checkin < checkout && reservation.checkout > checkin)
    end
    available
  end

  def change_host_status_to_true
    self.host.host = true
    self.host.save
  end

  def change_host_status_to_false
    if self.host.listings.size == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    ratings = self.reviews.collect{|review| review.rating}
    ratings.inject{ |sum, el| sum + el }.to_f / ratings.size
  end

end
