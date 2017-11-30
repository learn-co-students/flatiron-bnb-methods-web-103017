class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  validates :title, :description, :address, :listing_type, :price, :neighborhood_id, presence: true

  after_create :set_user
  after_destroy :reset_user

  def set_user
    @user = self.host
    @user.host = true
    @user.save
  end

  def reset_user
    @user = self.host
    if @user.listings.count == 0
      @user.host = false
      @user.save
    end
  end

  def average_review_rating
    counter = 0
    self.reservations.each do |res|
      counter += res.review.rating
    end
    counter.to_f / self.reservations.count.to_f
  end
end
