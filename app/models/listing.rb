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
  validates :neighborhood, presence: true

  after_create :host_status_true
  after_destroy :host_status_false


  def host_status_true
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def host_status_false
    user = User.find(self.host_id)
    if Listing.where(host: host).where.not(id: id).empty?
      user.host = false
    end
    user.save
  end


  def average_review_rating
    num_reviews = self.reviews.count
    total_rating = 0.0
    self.reviews.each{|review| total_rating += review.rating.to_f}
    total_rating/num_reviews
  end
end
