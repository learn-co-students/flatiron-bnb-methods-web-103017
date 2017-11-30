class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  include InstanceHelper
  extend ClassHelper

end
