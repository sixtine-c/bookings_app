class Mission < ApplicationRecord
  belongs_to :listing

  VALID_DATE_REGEX = /([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))/i

  validates :date, presence: true, format: { with: VALID_DATE_REGEX }

  validates :price, presence: true

  validates :listing_id, presence: true
end
