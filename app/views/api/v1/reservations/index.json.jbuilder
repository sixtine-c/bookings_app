json.array! @reservations do |reservation|
  json.extract! reservation, :id, :listing_id, :start_date, :end_date
end
