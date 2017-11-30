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


  before_save :switch_status
  def switch_status
    self.host.host = true
    self.host.save
  end


  before_destroy :no_listings

  def no_listings
    if self.host.listings.count == 1
      self.host.host = false
      self.host.save
    end
  end

  def average_review_rating
    sum = self.reviews.inject(0) do |acc, review|
      acc += review.rating
    end

    sum.to_f / self.reviews.count

  end
































end
