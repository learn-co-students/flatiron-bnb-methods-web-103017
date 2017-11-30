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

  before_save :change_host_status
  before_destroy :change_host_status_on_destroy

  def change_host_status
    # binding.pry
    user = User.find(self.host_id)
    user.host = true
    user.save
  end

  def change_host_status_on_destroy
    user = User.find(self.host_id)
    if user.listings.count == 1
      user.host = false
      user.save
    end
  end

  def average_review_rating
    # knows average ratings from its reviews
    total = self.reviews.reduce(0.0) do |sum, review|
      sum + review.rating
    end
    total.to_f / self.reviews.count.to_f

    # self.reviews.average(:rating)


  end

end
