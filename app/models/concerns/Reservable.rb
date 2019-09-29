module Reservable

  module InstanceMethods

    def openings(start_date, end_date)
      start_date = DateTime.parse(start_date)
      end_date = DateTime.parse(end_date)
      listings.select{ |listing| listing.available(start_date, end_date)}
    end

    def ratio_res_to_listings
      listings.count > 0 ? reservations.count.to_f/listings.count.to_f : 0
    end

  end


  module ClassMethods

    def highest_ratio_res_to_listings

      all.max { |a, b| a.ratio_res_to_listings <=> b.ratio_res_to_listings }
    end

    def most_res
      all.max { |a, b| a.reservations.count <=> b.reservations.count }
    end

  end

end
