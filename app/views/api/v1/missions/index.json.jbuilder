json.array! @missions do |mission|
  json.extract! mission, :id, :listing_id, :mission_type, :date, :price
end
