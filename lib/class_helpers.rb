module ClassHelper

  def highest_ratio_res_to_listings
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


  def most_res
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
