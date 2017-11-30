class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    self.neighborhoods.collect do |neighborhood|
      neighborhood.neighborhood_openings(checkin, checkout)
    end.flatten
  end



end
