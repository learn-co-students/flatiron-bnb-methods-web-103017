class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start, end_date)
    opens = []
    start = start.to_date
    end_date = end_date.to_date

    self.listings.each do |listing|
      good = true
      listing.reservations.each do |reservation|
        if (reservation.checkin...reservation.checkout).include?(start) || (reservation.checkin...reservation.checkout).include?(end_date)
          good = false
        end
      end
      opens << listing if good == true
    end
    opens
  end

  def self.highest_ratio_res_to_listings
    ratio = 0
    best_id = 0

    self.all.each do |neighborhood|
      if ratio < neighborhood.ratio
        ratio = neighborhood.ratio
        best_id = neighborhood.id
      end
    end

    self.find(best_id)

  end

  def ratio
    res_count = 0

    self.listings.each do |listing|
      res_count += listing.reservations.count
    end
    if self.listings.count != 0
      res_count / self.listings.count 
    else
      return 0
    end
  end

  def res_count
    res_count = 0
    self.listings.each do |listing|
      res_count += listing.reservations.count
    end
    res_count
  end


  def self.most_res
    self.all.inject do |neighborhood1, neighborhood2|
      neighborhood1.res_count > neighborhood2.res_count ? neighborhood1 : neighborhood2
    end
  end

end

























