class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true

  after_save :set_host
  after_destroy :reset_host

  # Returns true if all of the reservations of a given listing fall out side of the parameter dates
  def available(start_date, end_date)
    reservations.select {| reservation| reservation.available(start_date, end_date)} == reservations
  end

  def average_review_rating
    if !reviews.empty?
      reviews.map{|review| review.rating}.inject(0, :+).to_f/reviews.length
    end
    # reviews.average(:rating)
  end

  private

  def set_host
    unless host.host?
      host.update(host: true)
    end
  end

  def reset_host
    if host.listings.empty?
      host.update(host: false)
    end
  end



end
