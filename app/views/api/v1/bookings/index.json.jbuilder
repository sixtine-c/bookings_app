json.array! @bookings do |booking|
  json.extract! booking, :id, :listing_id, :start_date, :end_date
end
