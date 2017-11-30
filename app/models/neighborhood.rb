class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    master_arr = []
    self.listings.each do |listing|
      arr = []
      listing.reservations.each do |res|
        if res.checkout <= start_date.to_date || res.checkin >= end_date.to_date
          arr << true
        else
          arr << false
        end
      end
      if !arr.include?(false)
        master_arr << listing
      end
    end
    master_arr
  end

  def self.highest_ratio_res_to_listings
    highest_ratio = 0
    highest_n = ""
    self.all.each do |n|
      listings = n.listings.count
      reservations = n.listings.collect{|listing| listing.reservations}.flatten!
      if reservations != nil
        ratio = reservations.count.to_f / listings.to_f
        if ratio > highest_ratio || highest_ratio == 0
          highest_ratio = ratio
          highest_n = n
        end
      end
    end
    highest_n
  end

  def self.most_res
    most_reservations = 0
    n_most_res = ""
    self.all.each do |n|
      reservations = n.listings.collect{|listing| listing.reservations}.flatten!
      if reservations != nil
        tot_res = reservations.count
        if tot_res > most_reservations
          most_reservations = tot_res
          n_most_res = n
        end
      end
    end
    n_most_res
  end
end
