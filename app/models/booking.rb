class Booking < ApplicationRecord
  belongs_to :listing

  validates :start_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :end_date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :listing_id, presence: true

  validate :allow_dates, :bookings_must_not_overlap


  private
  def allow_dates
    if end_date <= start_date
      errors.add(:end_date, "can't be past or equal to start date")
    end
  end

  def bookings_must_not_overlap
    overlap_relation = Booking.where(listing_id: listing_id)
                           .where(
                               'DATE(bookings.start_date) < DATE(?) AND DATE(bookings.end_date) > DATE(?)',
                               end_date, start_date
                           )

    if overlap_relation.exists?
      errors.add(:start_date, "canot overlap another booking for this listing")
    end
  end
end
