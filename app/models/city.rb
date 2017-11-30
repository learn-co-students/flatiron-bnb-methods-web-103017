class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


  def city_openings(start, end_date)
    arr = self.neighborhoods.inject([]) do |acc, neighborhood|
      acc << neighborhood.neighborhood_openings(start, end_date)
    end
    arr = arr.reject &:empty?
    arr.flatten
  end

  def city_ratio
    total_res = 0
    total_list = 0

    self.neighborhoods.each do |neighborhood|
      total_list += neighborhood.listings.count
      neighborhood.listings.each do |listing|
        total_res += listing.reservations.count
      end
    end
    if total_list != 0
      total_res.to_f / total_list
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.inject do |city1, city2|
      city1.city_ratio > city2.city_ratio ? city1 : city2
    end
  end

  def res_count
    res_count = 0
    self.neighborhoods.each do |neighborhood|
      neighborhood.listings.each do |listing|
        res_count += listing.reservations.count
      end
    end
    res_count
  end


  def self.most_res
    self.all.inject do |city1, city2|
      city1.res_count > city2.res_count ? city1 : city2
    end
  end














end

