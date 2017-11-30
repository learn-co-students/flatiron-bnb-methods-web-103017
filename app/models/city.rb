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

  def self.highest_ratio_res_to_listings
    busiest_city = nil
    res_ratio = 0.0

    self.all.each do |city|
      total_res = 0
      city.listings.each do |listing|
        total_res += listing.reservations.count
      end
      if total_res.to_f / city.listings.count.to_f > res_ratio
        res_ratio = total_res.to_f / city.listings.count.to_f
        busiest_city = city
      end
    end
    busiest_city
  end

  def self.most_res
    busiest_city = nil
    most_res = 0
    self.all.each do |city|
      total_res = 0
      city.listings.each do |listing|
        total_res += listing.reservations.count
      end
      if total_res > most_res
        busiest_city = city
        most_res = total_res
      end
    end
    busiest_city
  end







end
