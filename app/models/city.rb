class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_input, end_input)
    # return all listing objects for span inputted

    start_date = DateTime.strptime(start_input, '%Y-%m-%d')
    end_date = DateTime.strptime(end_input, '%Y-%m-%d')

    # binding.pry
    @listings = Listing.all

    good_listings = []

    @listings.each do |listing| # REFACTOR LATER...PROBABLY NEVER
      # binding.pry
      listing_array = []
      listing.reservations.each do |reservation|
        if (reservation.checkin >= end_date || reservation.checkout <= start_date) == true
          listing_array << true
        else
          listing_array << false
        end
      end
      if listing_array.exclude?(false)
        good_listings << listing
      end
    end
    good_listings
  end

end
