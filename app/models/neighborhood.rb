class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    checkin_date = Date.parse(checkin)
    checkout_date = Date.parse(checkout)
    self.listings.select do |listing|
      listing.available?(checkin_date, checkout_date)
    end
  end
end
