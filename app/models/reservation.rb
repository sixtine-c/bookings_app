class Reservation < ApplicationRecord
  belongs_to :listing
  has_many :bookings, through: :listings
end
