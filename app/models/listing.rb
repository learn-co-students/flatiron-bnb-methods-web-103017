class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :title, :address, :listing_type, :description, :price, :neighborhood_id,  presence: true

  after_save :set_host_as_host
  before_destroy :unset_host_as_host

  def unset_host_as_host
   # remove .id
   if Listing.where(host: host).where.not(id: id).empty?
     host.update(host: false)
   end
 end

 def set_host_as_host
     host.update(host: true)
 end

 def average_review_rating
   self.reviews.collect{|x|x.rating}.inject(0){|sum,x| sum + x }.to_f/self.reviews.count.to_f
 end




end
