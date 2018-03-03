class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  extend Reservable::ClassMethods
  include Reservable::InstanceMethods

  # Returns an array of all of the listings that are available in a city within the the range in the parameters
  # def city_openings(start_date, end_date)
  #   start_date = DateTime.parse(start_date)
  #   end_date = DateTime.parse(end_date)
  #   listings.select{ |listing| listing.available(start_date, end_date)}
  # end

  def city_openings(start_date, end_date)
    openings(start_date, end_date)
  end

  # def self.most_res
  #   listings.max {|a, b| a.reservations <=> b.reservations }
  # end

end
